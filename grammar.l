Newline               \r?\n
Ws                    [ \t]
Int                   [0-9]+
Float                 [0-9]+\.[0-9]+
Char                  \"[A-Za-z0-9]\"|\"[^a-z\+]+\"
Number                [0-9]+("."[0-9]+)?
String                \"[^\;\+\-\*\\\%\"]+\"|\"[^\;]*\"
Identifier            [A-Za-z\$_][A-Za-z\$_0-9]*
Comment               \#.*\#
var                   @var
register              &register


%%

"for"                 {return 'FOR'; }
"if"                  {return 'IF'; }
"else"                {return 'ELSE'; }
"then"                {return 'THEN'; }
"loop"                {return 'REPEAT'; }
"end"                 {return 'END'; }
"go"                  {return 'GO'; }
"from"                {return 'FROM'; }
"to"                  {return 'TO'; }
"of"                  {return 'OF'; }
"when"                {return 'WHEN'; }
"return"              {return 'RETURN'; }
"function"            {return 'FUNCTION'; }
"struct"              {return 'STRUCT'; }
"property"            {return 'PROPERTY'; }
"--"                  {return '--'; }
"true"                { return "TRUE"; }
"false"               { return "FALSE"; }
"none"                {return "NONE"; }
"."                   {return "."; }
";"                   { return ";"; }
","				      { return ","; }
"=="				  { return '=='; }
"!="                  {return '!='; }
"->"                  {return '->'; }
"-"                   { return '-'; }
"+"                   { return '+'; }
"%"                   {return '%'; }
"*"                   { return '*'; }
"/"                   { return '/'; }
"("                   { return 'LP'; }
")"	                  { return 'RP'; }
":"                   {return ':'; }
"<-"                  {return '<-'; }
">"                   {return '>'; }
"<"                   {return '<'; }
"["                   {return '['; }
"]"                   {return ']'; }
{register}            {return 'REGISTER'; }
{var}                 {return 'VAR'; }
{Float}               { return 'FLOAT'; }
{Int}                 { return 'INT'; }
{Char}                {return 'CHAR'; }
{String}              { return 'STRING'; }
{Number}              { return 'NUMBER'; }
{Identifier}          { return 'IDENTIFIER'; }
{Ws}                  { /*skip whitespace*/ }
{Newline}             {}
{Comment}             {/*skip comment*/}