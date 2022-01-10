%{
#include <stdio.h>
#include <stdbool.h>
#include "limbaj.tab.h"
typedef struct Expr {
    int type_int;
    int intVal;
    bool boolVal;
    char charVal;
    float floatVal;
    char* strVal;
}Expr;
%}
%option noyywrap
%x comment
%%
"/*" {BEGIN comment;}
<comment>.|\n;
<comment>"*/" {BEGIN 0;}
"int"|"float"|"char"|"string"|"bool" {strcpy(yylval.strval, yytext);return TIP;}
"void" {strcpy(yylval.strval, yytext);return VOID;}
"constant" {return CONST;}
"structura" {return STRUCT;}
"begin_progr" {return BGIN;}
"end_progr" {return END;}
"if" { return MYIF; }
"while" { return MYWHILE; }
"for" { return MYFOR; }
"print" {return PRINT;}
@[_a-zA-Z][_a-zA-Z0-9]* {strcpy(yylval.strval, yytext);return ID;}
":=" {return ASSIGN;}
">" {return GT;}
">=" {return GET;}
"<" {return LT;}
"<=" {return LET;}
"==" {return EQ;}
"!=" {return NEQ;}
"!" {return NOT;}
"++" {return PLUSPLUS;}
"--" {return MINUSMINUS;}
"&&" {return SI;}
"||" {return SAU;}
"+" {return PLUS;}
"-" {return MINUS;}
"/" {return DIV;}
"%" { return MOD;}
"*" { return MUL;}
"fals" { yylval.boolval=false;return BOOL; }
"adevarat" { yylval.boolval=true;return BOOL; }
\'[a-zA-Z]\' {yylval.charval=yytext[1]; return CHAR; }
[0-9]+ {yylval.intval = atoi(yytext); return NR;}
[0-9]+[.][0-9]+ {yylval.floatval=atof(yytext); return FLOAT;}
([1-9]*[0-9],)*[1-9]*[0-9] {strcpy(yylval.strval, yytext);return INT_LIST;}
([0-9]+[.][0-9]+,)*[0-9]+[.][0-9]+ {strcpy(yylval.strval, yytext);return FLOAT_LIST;}
((adevarat|fals),)*(adevarat|fals) {strcpy(yylval.strval, yytext);return BOOL_LIST;}
\"[_a-zA-Z0-9!@#$%^&*()-+}{:;'"<>?,./ ][_a-zA-Z0-9!@#$%^&*()-+}{:;'"<>?,./ ]+\" {strcpy(yylval.strval, yytext);return CUVANT;}
[ \t] ;
\n {yylineno++;}
\r ;
. {return yytext[0];}
