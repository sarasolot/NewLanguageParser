%left '+' '-' '<' '>' '!=' '=='
%left '*' '/' '%'


%%

start: statements           {
                                return {
                                        id: 'script',
                                        statements: $1,
                                        line: yylineno + 1
                                }
                            }            
;
statements
: statements statement ';'  {
                                $1.push($2);
                                $$ = $1;
                            }
| statement ';'             {
                                $$ = [];
                                $$.push($1);
                            }
;
statement
: expr
| expr_string
| variable
| attr
| loop
| function
| return
| function_call
| branch
| array
| struct
;
expr
: expr '+' expr                 {
                                    $$ = {
                                            id: 'expr',
                                            op: $2,
                                            left: $1,
                                            right: $3,
                                            line: yylineno + 1
                                        };
                                }
| expr '+' expr_string          {
                                    $$ = { id: 'expr',
                                            op: $2,
                                            left: $1,
                                            right: $3,
                                            line: yylineno + 1
                                        };
                                }
| expr '-' expr                 {
                                    $$ = {
                                            id: 'expr',
                                            op: $2,
                                            left: $1,
                                            right: $3,
                                            line: yylineno + 1
                                        };
                                }
| expr '*' expr                 {
                                   $$ = {
                                            id: 'expr',
                                            op: $2,
                                            left: $1,
                                            right: $3,
                                            line: yylineno + 1
                                        }; 
                                }
| expr '/' expr                 {
                                   $$ = {
                                            id: 'expr',
                                            op: $2,
                                            left: $1,
                                            right: $3,
                                            line: yylineno + 1
                                        }; 
                                }
| expr '<' expr                 {
                                   $$ = {
                                            id: 'expr',
                                            op: $2,
                                            left: $1,
                                            right: $3,
                                            line: yylineno + 1
                                        }; 
                                }
| expr '>' expr                 {
                                   $$ = {
                                            id: 'expr',
                                            op: $2,
                                            left: $1,
                                            right: $3,
                                            line: yylineno + 1
                                        }; 
                                }
| expr '%' expr                 {
                                    $$ = {
                                            id: 'expr',
                                            op: 'mod',
                                            left: $1,
                                            right: $3,
                                            line: yylineno + 1
                                    };
                                }
| expr '==' expr                {
                                    $$ = {
                                            id: 'expr',
                                            op: $2,
                                            left: $1,
                                            right: $3,
                                            line: yylineno + 1
                                    };
                                }
| expr '!=' expr                {
                                    $$ = {
                                            id: 'expr',
                                            op: $2,
                                            left: $1,
                                            right: $3,
                                            line: yylineno + 1
                                    };
                                }
| IDENTIFIER                    {
                                    $$= {
                                            id: 'identifier',
                                            title: $1,
                                            line: yylineno + 1
                                        };
                                }
| INT                           {
                                    $$ = {
                                        id: 'value',
                                        type: 'int',
                                        value: JSON.parse($1),
                                        line: yylineno + 1
                                    };
                                }
|   FLOAT                       {
                                    $$ = {
                                        id: 'value',
                                        type: 'real',
                                        value: JSON.parse($1),
                                        line: yylineno + 1
                                    };
                                }
| TRUE                          {
                                    $$ = {
                                        id: 'value',
                                        type: 'logic',
                                        value: JSON.parse($1),
                                        line: yylineno + 1
                                    };
                                }
|   FALSE                       {
                                     $$ = {
                                        id: 'value',
                                        type: 'logic',
                                        value: JSON.parse($1),
                                        line: yylineno + 1
                                    };
                                }
| NONE                          {
                                     $$ = {
                                        id: 'value',
                                        type: 'none',
                                        line: yylineno + 1
                                    };
                                }
|                               {
                                    $$ = {
                                        type: 'empty',
                                    };
                                }
;
expr_string
:   expr_string '+' expr_string  {
                                    $$ = { id: 'expr',
                                            op: $2,
                                            left: $1,
                                            right: $3,
                                            line: yylineno + 1
                                        }
                                }
| expr_string '+' expr          {
                                    $$ = { id: 'expr',
                                            op: $2,
                                            left: $1,
                                            right: $3,
                                            line: yylineno + 1
                                        };
                                }
| STRING                        {
                                    $$ = {
                                        id: 'value',
                                        type: 'string',
                                        value: JSON.parse($1),
                                        line: yylineno + 1
                                    };
                                }
| CHAR                          {
                                    $$ = {
                                        id: 'value',
                                        type: 'character',
                                        value: JSON.parse($1),
                                        line: yylineno + 1
                                    };
                                }
;
variable
: VAR variables                 {   
                                    $$ = {
                                            id: 'var',
                                            elements: $2,
                                            line: yylineno + 1
                                    };
                                }
;
variables
: variables ',' IDENTIFIER ':' IDENTIFIER                       {
                                                                    $1.push({
                                                                        type: $5,
                                                                        title: $3,
                                                                        line: yylineno + 1
                                                                    });
                                                                    $$ = $1;
                                                                }
| variables ',' IDENTIFIER ':' IDENTIFIER '<-' expr             {
                                                                    $1.push({
                                                                        type: $5,
                                                                        title: $3,
                                                                        value: $7,
                                                                        line: yylineno + 1
                                                                    });
                                                                    $$ = $1;
                                                                }
| variables ',' IDENTIFIER ':' IDENTIFIER '<-' expr_string      {
                                                                    $1.push({
                                                                        type: $5,
                                                                        title: $3,
                                                                        value: $7,
                                                                        line: yylineno + 1
                                                                    });
                                                                    $$ = $1;
                                                                }
| IDENTIFIER ':' IDENTIFIER '<-' expr                           {
                                                                    $$ = [];
                                                                    $$.push({
                                                                            type: $3,
                                                                            title: $1,
                                                                            value: $5,
                                                                            line: yylineno + 1
                                                                    });
                                                                }
| IDENTIFIER ':' IDENTIFIER '<-' expr_string                    {
                                                                    $$ = [];
                                                                    $$.push({
                                                                            type: $3,
                                                                            title: $1,
                                                                            value: $5,
                                                                            line: yylineno + 1
                                                                    });
                                                                }
| IDENTIFIER '<-' expr                                          {
                                                                    $$ = [];
                                                                    $$.push({
                                                                            type: 'auto',
                                                                            title: $1,
                                                                            value: $3,
                                                                            line: yylineno + 1
                                                                        });
                                                                }
| IDENTIFIER '<-' expr_string                                   {
                                                                    $$ = [];
                                                                    $$.push({
                                                                            type: 'auto',
                                                                            title: $1,
                                                                            value: $3,
                                                                            line: yylineno + 1
                                                                        });
                                                                }
| IDENTIFIER ':' IDENTIFIER                                     {   
                                                                    $$ = [];
                                                                    $$.push({
                                                                            type: $3,
                                                                            title: $1,
                                                                            line: yylineno + 1
                                                                    });
                                                                }
;
attr
: IDENTIFIER '<-' function_call                                 {
                                                                    $$ = {
                                                                            id: 'attr',
                                                                            to: {
                                                                                id: 'identifier',
                                                                                title: $1,
                                                                                line: yylineno + 1
                                                                            },
                                                                            from: $3,
                                                                            line: yylineno + 1
                                                                        };
                                                                }
| IDENTIFIER '<-' expr                                          {
                                                                    $$ = {
                                                                            id: 'attr',
                                                                            to: {
                                                                                id: 'identifier',
                                                                                title: $1,
                                                                                line: yylineno + 1
                                                                            },
                                                                            from: $3,
                                                                            line: yylineno + 1
                                                                        };
                                                                }
| IDENTIFIER '<-' expr_string                                   {
                                                                    $$ = {
                                                                            id: 'attr',
                                                                            to: {
                                                                                id: 'identifier',
                                                                                title: $1,
                                                                                line: yylineno + 1
                                                                            },
                                                                            from: $3,
                                                                            line: yylineno + 1
                                                                        };
                                                                }
| array_acces '<-' expr                                         {
                                                                    $$ = {
                                                                                id: 'attr',
                                                                                to: $1,
                                                                                from: $3,
                                                                                line: yylineno + 1
                                                                        };
                                                                }
| array_acces '<-' expr_string                                  {
                                                                    $$ = {
                                                                                id: 'attr',
                                                                                to: $1,
                                                                                from: $3,
                                                                                line: yylineno + 1
                                                                            };
                                                                }
| struct_acces '<-' expr                                        {
                                                                    $$ = {
                                                                            id: 'attr',
                                                                            to: $1,
                                                                            from: $3,
                                                                            line: yylineno + 1
                                                                    };
                                                                } 
| struct_acces '<-' expr_string                                 {
                                                                    $$ = {
                                                                            id: 'attr',
                                                                            to: $1,
                                                                            from: $3,
                                                                            line: yylineno + 1
                                                                    };
                                                                }
;
loop
: FOR IDENTIFIER FROM expr TO expr GO statements END            {
                                                                    $$ = {
                                                                            id: 'for',
                                                                            variable: $2,
                                                                            from: {
                                                                                    id: $4.id,
                                                                                    type: $4.type,
                                                                                    value: $4.value,
                                                                                    title: $4.title,
                                                                                    line: $4.line
                                                                            },
                                                                            to: {
                                                                                    id: $6.id,
                                                                                    type: $6.type,
                                                                                    value: $6.value,
                                                                                    title: $6.title,
                                                                                    line: $6.line
                                                                            },
                                                                            statements: $8, 
                                                                            line: yylineno + 1
                                                                    };
                                                                }
| FOR IDENTIFIER FROM expr TO function_call GO statements END   {
                                                                    $$ = {
                                                                            id: 'for',
                                                                            variable: $2,
                                                                            from: {
                                                                                    id: $4.id,
                                                                                    type: $4.type,
                                                                                    value: $4.value,
                                                                                    title: $4.title,
                                                                                    line: $4.line
                                                                            },
                                                                            to: {
                                                                                    id: $6.id,
                                                                                    function: $6.function,
                                                                                    parameters: $6.parameters,
                                                                                    line: $6.line
                                                                            },
                                                                            statements: $8, 
                                                                            line: yylineno + 1
                                                                        };
                                                                } 
| FOR IDENTIFIER OF IDENTIFIER GO statements END                {
                                                                        $$ = {
                                                                                id: 'for',
                                                                                variable: $2,
                                                                                exp: {
                                                                                        id: 'identifier',
                                                                                        title: $4,
                                                                                        line: yylineno - 1
                                                                                },
                                                                                statements: $6,
                                                                                line: yylineno + 1
                                                                        };
                                                                }
| REPEAT statements WHEN expr                                   {
                                                                        $$ = {
                                                                                id: 'loop_when',
                                                                                    exp: {
                                                                                    id: $4.id,
                                                                                    op: $4.op,
                                                                                    left: {
                                                                                        id: $4.left.id,
                                                                                        title: $4.left.title,
                                                                                        line: $4.left.line
                                                                                    },
                                                                                    right: {
                                                                                        id: $4.right.id,
                                                                                        type: $4.right.type,
                                                                                        value: $4.right.value,
                                                                                        line: $4.right.line
                                                                                    },
                                                                                    line: $4.line
                                                                                },
                                                                                statements: $2,
                                                                                line: yylineno + 1
                                                                        };
                                                                }
| REPEAT expr GO statements END                                 {
                                                                        $$ = {
                                                                                id: 'loop_go',
                                                                                exp: {
                                                                                        id: $2.id,
                                                                                        op: $2.op,
                                                                                        left: {
                                                                                            id: $2.left.id,
                                                                                            title: $2.left.title,
                                                                                            line: $2.left.line
                                                                                        },
                                                                                        right: {
                                                                                            id: $2.right.id,
                                                                                            type: $2.right.type,
                                                                                            value: $2.right.value,
                                                                                            line: $2.right.line
                                                                                        },
                                                                                        line: $2.line
                                                                                },
                                                                                statements: $4,
                                                                                line: yylineno + 1
                                                                        };
                                                                }
;
function
: FUNCTION IDENTIFIER parameters ':' IDENTIFIER IDENTIFIER statements END   {
                                                                                $$ = {
                                                                                        id: 'function_def',
                                                                                        title: $2,
                                                                                        parameters: $3,
                                                                                        return_type: $5,
                                                                                        statements: $7,
                                                                                        line: yylineno + 1
                                                                                };
                                                                        }
| FUNCTION IDENTIFIER LP parameters RP ':' IDENTIFIER IDENTIFIER statements END {
                                                                                    $$ = {
                                                                                    id: 'function_def',
                                                                                    title: $2,
                                                                                    parameters: $4,
                                                                                    return_type: $7,
                                                                                    statements: $9,
                                                                                    line: yylineno + 1
                                                                                    };
                                                                                }
| FUNCTION IDENTIFIER LP parameters RP ':' IDENTIFIER state                     {
                                                                                    $$ = {
                                                                                            id: 'function_def',
                                                                                            title: $2,
                                                                                            parameters: $4,
                                                                                            return_type: $7,
                                                                                            statements: $8,
                                                                                            line: yylineno + 1
                                                                                    };
                                                                                }
| FUNCTION IDENTIFIER parameters ':' IDENTIFIER state                           {
                                                                                    $$ = {
                                                                                            id: 'function_def',
                                                                                            title: $2,
                                                                                            parameters: $3,
                                                                                            return_type: $5,
                                                                                            statements: $6,
                                                                                            line: yylineno + 1
                                                                                    };
                                                                                }
;
state
: '->' expr                                                                     {
                                                                                    $$ = [];
                                                                                    $$.push({
                                                                                            id: $2.id,
                                                                                            type: $2.type,
                                                                                            value: $2.value,
                                                                                            line: $2.line
                                                                                    });
                                                                                }
| '->' expr_string                                                              {
                                                                                    $$ = [];
                                                                                    $$.push({
                                                                                            id: $2.id,
                                                                                            type: $2.type,
                                                                                            value: $2.value,
                                                                                            line: $2.line
                                                                                    });
                                                                                }
;
parameters
: parameters ',' IDENTIFIER ':' IDENTIFIER                                      {
                                                                                    $1.push({
                                                                                            type: $5,
                                                                                            name: $3
                                                                                    });
                                                                                    $$ = $1;
                                                                                }
| IDENTIFIER ':' IDENTIFIER                                                     {
                                                                                    $$ =[];
                                                                                    $$.push({
                                                                                            type: $3,
                                                                                            name: $1
                                                                                    });
                                                                                }
|                                                                               {
                                                                                    $$ = [];
                                                                                }
;                             
return
: RETURN expr                                                                   {
                                                                                    $$ = {
                                                                                        id: 'return',
                                                                                        value: {
                                                                                            id: $2.id,
                                                                                            title: $2.title,
                                                                                        line: $2.line
                                                                                        },
                                                                                        line: yylineno + 1
                                                                                    };
                                                                                }
;
function_call
: IDENTIFIER LP parameters_call RP                                              {
                                                                                    $$ = {
                                                                                            id: 'function_call',
                                                                                            function: $1,
                                                                                            parameters: $3,
                                                                                            line: yylineno + 1
                                                                                        };
                                                                                }                
;
parameters_call
: IDENTIFIER ':' expr                                                           {   
                                                                                    $$ = {
                                                                                            [$1]: $3
                                                                                        };
                                                                                }
| IDENTIFIER ':' expr ',' IDENTIFIER ':' statement                              {
                                                                                    $$ = {
                                                                                            [$1]: $3,
                                                                                            [$5]: $7
                                                                                        };
                                                                                }
|IDENTIFIER ':' expr_string                                                     {
                                                                                    $$ = {
                                                                                            [$1]: $3
                                                                                        };
                                                                                }
| IDENTIFIER ':' expr_string ',' IDENTIFIER ':' statement                       {
                                                                                    $$ = {
                                                                                            [$1]: $3,
                                                                                            [$5]: $7
                                                                                            
                                                                                        };
                                                                                }
|                                                                               {
                                                                                    $$ = [];
                                                                                }
;
branch
: IF statement THEN statements END                                              {
                                                                                    $$ = {
                                                                                            id: 'if_then',
                                                                                            exp: $2,
                                                                                            then: $4,
                                                                                            line: yylineno + 1
                                                                                    };
                                                                                }
| IF statement THEN statements ELSE statements END                              {
                                                                                    $$ = {
                                                                                            id: 'if_then',
                                                                                            exp: $2,
                                                                                            then: $4,
                                                                                            else: $6,
                                                                                            line: yylineno + 1
                                                                                    };
                                                                                }
;
struct
: STRUCT IDENTIFIER PROPERTY property ';' END                                   {
                                                                                    $$ = {
                                                                                            id: 'struct_def',
                                                                                            title: $2,
                                                                                            properties: $4
                                                                                    };
                                                                                }
| STRUCT IDENTIFIER property END                                                {
                                                                                    $$ = {
                                                                                            id: 'struct_def',
                                                                                            title: $2,
                                                                                            properties: $3
                                                                                    };
                                                                                }
;
property
: IDENTIFIER ':' IDENTIFIER                                                     {
                                                                                    $$ = [];
                                                                                    $$.push({
                                                                                                type: $3,
                                                                                                title: $1,
                                                                                                line: yylineno + 1
                                                                                    });
                                                                                }
| property ';' PROPERTY IDENTIFIER ':' IDENTIFIER                               {
                                                                                    $1.push({
                                                                                                type: $6,
                                                                                                title: $4,
                                                                                                line: yylineno + 1
                                                                                    });
                                                                                    $$ = $1;
                                                                                }
| IDENTIFIER ':' IDENTIFIER '<-' expr                                           {
                                                                                    $$ = [];
                                                                                    $$.push({
                                                                                                type: $3,
                                                                                                title: $1,
                                                                                                value: $5,
                                                                                                line: yylineno + 1
                                                                                    });
                                                                                }
| property ';' PROPERTY IDENTIFIER ':' IDENTIFIER '<-' expr                     {
                                                                                    $1.push({
                                                                                        type: $6,
                                                                                        title: $4,
                                                                                        value: $8,
                                                                                        line: yylineno + 1
                                                                                    });
                                                                                    $$ = $1;
                                                                                }
| IDENTIFIER ':' IDENTIFIER '<-' expr_string                                    {
                                                                                    $$ = [];
                                                                                    $$.push({
                                                                                                type: $3,
                                                                                                title: $1,
                                                                                                value: $5,
                                                                                                line: yylineno + 1
                                                                                    });
                                                                                }
| property ';' PROPERTY IDENTIFIER ':' IDENTIFIER '<-' expr_string              {
                                                                                    $1.push({
                                                                                        type: $6,
                                                                                        title: $4,
                                                                                        value: $8,
                                                                                        line: yylineno + 1
                                                                                    });
                                                                                    $$ = $1;
                                                                                }
|                                                                               {
                                                                                    $$ = [];
                                                                                }
;
struct_acces
: IDENTIFIER '.' IDENTIFIER                                                     {
                                                                                    $$ = {
                                                                                            id: 'prop',
                                                                                            object: {
                                                                                                id: 'identifier',
                                                                                                title: $1,
                                                                                                line: yylineno + 1
                                                                                            },
                                                                                            title: $3,
                                                                                            line: yylineno + 1
                                                                                    };
                                                                                }
| array_acces '.' IDENTIFIER                                                    {
                                                                                    $$ = {
                                                                                            id: 'prop',
                                                                                            object: $1,
                                                                                            title: $3,
                                                                                            line: yylineno + 1
                                                                                    };
                                                                                }
;
array
: IDENTIFIER ':' IDENTIFIER '[' INT '--' INT ']'                                {
                                                                                    $$ = {
                                                                                            id: 'vector',
                                                                                            title: $1,
                                                                                            element_type: $3,
                                                                                            from : $5,
                                                                                            to: $7,
                                                                                            line: yylineno + 1
                                                                                    };
                                                                                }
;
array_acces
: IDENTIFIER '[' expr ']'                                                       {
                                                                                    $$ = {
                                                                                            id: 'element_of_vector',
                                                                                            array: $1,
                                                                                            index: $3,
                                                                                            line: yylineno + 1
                                                                                    };
                                                                                }
| IDENTIFIER '[' array_acces ']'                                                {
                                                                                    $$ = {
                                                                                            id: 'element_of_vector',
                                                                                            array: $1,
                                                                                            index: $3,
                                                                                            line: yylineno + 1
                                                                                    };
                                                                                }
| IDENTIFIER '[' function_call ']'                                              {
                                                                                    $$ = {
                                                                                            id: 'element_of_vector',
                                                                                            array: $1,
                                                                                            index: $3,
                                                                                            line: yylineno + 1
                                                                                    };
                                                                                }
| IDENTIFIER '[' struct_acces ']'                                               {
                                                                                    $$ = {
                                                                                            id: 'element_of_vector',
                                                                                            array: $1,
                                                                                            index: $3,
                                                                                            line: yylineno + 1
                                                                                    };
                                                                                }
;                                                     