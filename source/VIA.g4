/*
Copyright (c) 2015 Paul Austin

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

grammar VIA;

viaStream
    : symbol (symbol)*
    ;

symbol
    : NAMED_SYMBOL
    | literal
    | temaplate
    | invoke
    | array
    | jsonArray
    | jsonCluster
    ;

literal
    : STRING
    | NUMBER
    | BOOLEAN
    ;

//------------------------------------------------------------
array
    : '('  element* ')' ;

jsonArray
    : '[' symbol? (',' symbol)* ']' ;

jsonCluster
    : '{' (fieldName symbol)? (',' fieldName symbol)* '}' ;

element
    : (fieldName? symbol)
    ;

//------------------------------------------------------------
// Symbols can be used in three forms,
// Simple, templated, and call.

// Simple is a the symbol token followed by WS
NAMED_SYMBOL: SYMBOL_CORE ;

fieldName: FIELD_NAME ;
FIELD_NAME:  SYMBOL_CORE ':' ;

// Template is a the symbol token followed by '<' no WS
temaplate: TEMPLATED_SYMBOL symbol* CLOSE;
TEMPLATED_SYMBOL: SYMBOL_CORE OPEN_TEMPLATE ;
fragment OPEN_TEMPLATE: '<';
CLOSE: '>';

// Invoke is a the symbol token followed by '(' no WS
invoke: INVOKE_SYMBOL symbol* CLOSE_INVOKE;
INVOKE_SYMBOL: SYMBOL_CORE OPEN_INVOKE;
fragment OPEN_INVOKE: '(';
CLOSE_INVOKE: ')';

fragment SYMBOL_CORE : ('*' | (PERCENT_ESC | [._a-zA-Z]) (PERCENT_ESC | [._a-zA-Z0-9])*) ;
fragment PERCENT_ESC : '%' HEX HEX;

//------------------------------------------------------------
// Strings come in two formats
STRING: (ESCAPED_STRING | VERBATIM_STRING);

//------------------------------------------------------------
// Escaped strings have C / JSON like back slash escapes
// and must msut be on a sinlge line.
fragment ESCAPED_STRING
    : (ESCAPED_SQ | ESCAPED_DQ);

fragment ESCAPED_SQ : '\'' (ESC | ~[\'\\\n\r])* '\'' ;
fragment ESCAPED_DQ : '"' (ESC |  ~["\\\n\r])* '"' ;

fragment ESC : ('\\' (["\'\\/bfnrt])) ;
fragment HEX : [0-9a-fA-F] ;

//------------------------------------------------------------
// Verbatim strings continue untile the mathcing delimeter.
// as the name implies its verbatim so there is no way to
// escape the initial delimeter.
fragment VERBATIM_STRING
    : '@' (VERBATIM_SQ | VERBATIM_DQ);

fragment VERBATIM_SQ : '\'' (~[\'])* '\'';
fragment VERBATIM_DQ : '"' (~["])* '"';

BOOLEAN
    : 'true'
    | 'false'
    ;

//------------------------------------------------------------
// Numbers, both integer and IEEE754
// Adapted from ANTLR's JSON grammar
NUMBER
    :   '-'? INT '.' [0-9]+ EXP? // 1.35, 1.35E-9, 0.3, -4.5
    |   '-'? INT EXP             // 1e10 -3e4
    |   '-'? INT                 // -3, 45
    |   [+\-]? ('nan' | 'NaN')
    |   [+\-]? ('inf' | 'Infinity')
    ;

fragment INT :   '0' | [1-9] [0-9]* ; // no leading zeros
fragment EXP :   [Ee] [+\-]? INT ;    // \- since - means "range" inside [...]

//------------------------------------------------------------
WS  :   [ \t\n\r]+ -> skip ;
