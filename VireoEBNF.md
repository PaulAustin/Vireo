## EBNF gramar for Vireo script files

Symbols are the core. All Symbols have a strucure, the structure holds
bits. the bits interpreted via encoding defined with the structure
make a value.

Symbols can be defined from the perpsective of a value, or by describing
the structure


### Grammar for Vireo script files

symbol_expression       := ( value_literal
                            | type_literal
                            | symbol )


statement               := ( declaration
                            | assignmnet
                            | map_expression
                            | iterate_expresson
                            | condition_expression
                            | clump_expression )

value_literal           :=  ( simple_string             // String
                            | simple_numeric            // Int32 or Double
                            | simple_boolean            // Boolean
                            | simple_array              // Type of elt 0
                            | simple_cluster            // Type based by field
                            | type_based_constructor )  // type base on type

simple_string           :=  ( literal_quoted_string
                            | escaped_quoted_string )

escaped_quoted_string   := '@' literal_quoted_string

literal_quoted_string   := single_quote_string | double_quote_string

single_quote_string     := '’'  characters_possibly_with_escapes '’'

double_quote_string     := '"'  characters_possibly_with_escapes '"'


simple_numeric          :=  integer_numeric | ieee745_numeric

integer_numeric         := [1-9] [0-9]*

ieee745_numeric         :=  integer_numeric '.' [0-9]*
                            { ('+' | '-') 'e' integer_numeric }


declaration             := symbol '=' symbol_expression

assignment              := symbol '<-' symbol_expression
