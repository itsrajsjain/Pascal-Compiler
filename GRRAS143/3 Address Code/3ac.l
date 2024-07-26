%{
#include "y.tab.h"
#include <stdio.h> 
#include <strings.h>
%}

A [aA]
B [bB]
C [cC]
D [dD]
E [eE]
F [fF]
G [gG]
H [hH]
I [iI]
J [jJ]
K [kK]
L [lL]
M [mM]
N [nN]
O [oO]
P [pP]
Q [qQ]
R [rR]
S [sS]
T [tT]
U [uU]
V [vV]
W [wW]
X [xX]
Y [yY]
Z [zZ]

%%

{A}{N}{D} {return T_AND;}
{A}{R}{R}{A}{Y} {return T_ARRAY;}
{B}{E}{G}{I}{N} {return T_BEGIN;}
{D}{O} {return T_DO;}
{D}{O}{W}{N}{T}{O} {return T_DOWNTO;}
{E}{L}{S}{E} {return T_ELSE;}
{E}{N}{D} {return T_END;}
{F}{O}{R} {return T_FOR;}
{I}{F} {return T_IF;}
{N}{O}{T} {return T_NOT;}
{O}{F} {return T_OF;}
{O}{R} {return T_OR;}
{P}{R}{O}{G}{R}{A}{M} {return T_PROGRAM;}
{R}{E}{A}{D} {return T_READ;}
{T}{H}{E}{N} {return T_THEN;}
{T}{O} {return T_TO;}
{V}{A}{R} {return T_VAR;}
{W}{H}{I}{L}{E} {return T_WHILE;}
{W}{R}{I}{T}{E} {return T_WRITE;}
{I}{N}{T}{E}{G}{E}{R} {return T_INTEGER_TYPE;}
{R}{E}{A}{L} {return T_REAL_TYPE;}
{C}{H}{A}{R} {return T_CHAR_TYPE;}
{B}{O}{O}{L}{E}{A}{N} {return T_BOOLEAN_TYPE;}

":=" {return T_ASSIGN;}
":" {return T_COLON;}
"," {return T_COMMA;}
"." {return T_DOT;}
".." {return T_DOTDOT;}
"=" {return T_EQUAL;}
">=" {return T_GE;}
">" {return T_GT;}
"[" {return T_LB;}
"<=" {return T_LE;}
"(" {return T_LP;}
"<" {return T_LT;}
"-" {return T_MINUS;}
"<>" {return T_UNEQUAL;}
"+" {return T_PLUS;}
"]" {return T_RB;}
")" {return T_RP;}
";" {return T_SEMI;}
"/" {return T_DIV;}
"*" {return T_MUL;}
"%" {return T_MOD;}



[a-zA-Z][_a-zA-Z0-9]*  {strcpy(yylval.t.str,yytext);return T_ID;}
[0-9]+                  {yylval.t.v.ival=atoi(yytext);return T_INT;}
[0-9]+"."[0-9]+         {yylval.t.v.fval=atof(yytext);return T_REAL;}
\"[^\"\n]*\"    {strcpy(yylval.t.str,yytext);return T_STRING;} /* String token */
[\t\f] {}
[\n]   {}
" " {}
"//"(.)*"\n"    {/* Ignore single-line comments */}

. {return -1;} // Handle unrecognized characters


%%
