%{
#include "rough.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
extern int yylex();
extern int yyparse();
extern FILE *yyin;
extern FILE *file;
#define MAX_LEN 10000

%}

%union{
      struct {
        char * type;
        char str[1000];
        union{
            int ival;
            float fval;
            char* sval;
        }v;
    }t;
}

%left T_LT T_GT T_LE T_GE T_EQUAL T_UNEQUAL
%left T_PLUS T_MINUS T_OR
%left T_MUL T_DIV T_MOD T_AND
%right T_NOT

%token <t>T_PROGRAM T_VAR
%token <t>T_INT
%token <t>T_REAL
%token <t>T_ID
%token <t>T_STRING
%token <t>T_BEGIN T_END
%token <t>T_READ T_WRITE
%token <t>T_IF T_THEN T_ELSE T_WHILE T_DO T_TO T_DOWNTO T_FOR
%token <t>T_EQUAL T_UNEQUAL T_GE T_GT T_LE T_LT T_ASSIGN T_PLUS T_MINUS T_MUL T_DIV T_OR T_AND T_NOT T_MOD
%token <t>T_LB T_RB T_LP T_RP T_SEMI T_DOT T_DOTDOT T_COMMA T_COLON
%token <t>T_INTEGER_TYPE T_BOOLEAN_TYPE T_CHAR_TYPE T_REAL_TYPE
%token <t>T_ARRAY T_OF

%type <t> assign_expr assign_stmt var_decl_list var_declaration main var_decl name_list type_dec type 
%type <t> array_type_decl x const_value stmt_list stmt x1 y write_stmt read_stmt block_stmt variable_list
%type <t> cond_stmt loop_stmt boolean_expr relational_expr expr id num array_access condition

%start S

%%

S: T_PROGRAM T_ID T_SEMI var_declaration main T_DOT {
char result[100];
sprintf(result,"[PROGRAM%s%s%s]",$<t.str>2,$<t.str>4,$<t.str>5);
strcpy($<t.str>$,result);
TreeNode* root = createTree(result);

// Open the file for writing

    FILE *file = fopen("p1.txt", "w");



    // Check if the file was opened successfully

    if (file == NULL) {

        perror("Error opening file");

        return 1; // Return an error code

    }

fprintf(file, "%s", result);

fclose(file);
treeTraversal(root);

}
;

var_declaration: T_VAR var_decl_list {
char result[100];
sprintf(result,"[VAR%s]",$<t.str>2);
strcpy($<t.str>$,result);
}
| 
;

var_decl_list: var_decl_list var_decl
{
sprintf($<t.str>$,"%s%s",$<t.str>1,$<t.str>2);
}
| var_decl
{
strcpy($<t.str>$,$<t.str>1);
}
;

var_decl: name_list T_COLON type_dec T_SEMI
{
char result[1000];
sprintf(result,"[%s%s]",$<t.str>3,$<t.str>1);
strcpy($<t.str>$,result);
}
;

name_list: T_ID T_COMMA name_list{
declareVariable($<t.v.sval>1,"");
char result[1000];
sprintf(result,"[{,}[id:{%s}]%s]",$<t.str>1,$<t.str>3);
strcpy($<t.str>$,result);
}
| T_ID{
declareVariable($<t.v.sval>1,"");
char result[1000];
sprintf(result,"[id:{%s}]",$<t.str>1);
strcpy($<t.str>$,result);
}
;

type_dec: type{setType($<t.type>1);strcpy($<t.str>$,$<t.str>1);}
| array_type_decl{strcpy($<t.str>$,$<t.str>1);}
;

type: T_INTEGER_TYPE
{
$<t.type>$=$<t.type>1;
strcpy($<t.str>$,"INTEGER");
}
|T_BOOLEAN_TYPE{
$<t.type>$=$<t.type>1;
strcpy($<t.str>$,"BOOLEAN");
}
|T_CHAR_TYPE{
$<t.type>$=$<t.type>1;
strcpy($<t.str>$,"CHAR");
}
|T_REAL_TYPE{
$<t.type>$=$<t.type>1;
strcpy($<t.str>$,"REAL");
}
;

array_type_decl: T_ARRAY T_LB x T_RB T_OF type{
setarraytype($<t.type>6);

char result[100];
sprintf(result,"ARRAYOF%s",$<t.str>6);
strcpy($<t.str>$,result);
}
;

x: const_value T_DOTDOT const_value{
char result[100];
sprintf(result,"[%s[..]%s]",$<t.str>1,$<t.str>3);
strcpy($<t.str>$,result);
if(strcasecmp($<t.type>$,"integer")==0){
int start=$<t.v.ival>1;
int end=$<t.v.ival>3;
for(int i=start;i<end;i++){
addToSymbolTable("","");
}
}

}
;

const_value: num{$<t.type>$=$<t.type>1;strcpy($<t.str>$,$<t.str>1);
if(strcasecmp($<t.type>$,"integer")==0){
$<t.v.ival>$=$<t.v.ival>1;
}
else $<t.v.fval>$=$<t.v.fval>1;
}
|T_MINUS num{
$<t.type>$=$<t.type>2;
char result[100];
sprintf(result,"[-%s]",$<t.str>2);
strcpy($<t.str>$,result);
}
;

num: T_INT {
$<t.type>$=$<t.type>1;
sprintf($<t.str>$,"const:{%s}",$<t.str>1);
$<t.v.ival>$=$<t.v.ival>1;
}
| T_REAL 

{
$<t.type>$=$<t.type>1;
sprintf($<t.str>$,"const:{%s}",$<t.str>1);
$<t.v.fval>$=$<t.v.fval>1;
}
;

main: T_BEGIN stmt_list T_END {
char result[1000];
sprintf(result, "[MAIN[BEGIN]%s[END]]", $<t.str>2);
strcpy($<t.str>$,result);
}
;

stmt_list: stmt T_SEMI stmt_list{
char result[1000];
sprintf(result, "%s%s", $<t.str>1,$<t.str>3);
strcpy($<t.str>$,result);
}
| stmt T_SEMI {
char result[1000];
sprintf(result, "%s", $<t.str>1);
strcpy($<t.str>$,result);
}
;

stmt: write_stmt {strcpy($<t.str>$,$<t.str>1);}
| read_stmt {strcpy($<t.str>$,$<t.str>1);}
| assign_stmt {strcpy($<t.str>$,$<t.str>1);}
| block_stmt{strcpy($<t.str>$,$<t.str>1);}
| cond_stmt {strcpy($<t.str>$,$<t.str>1);}
| loop_stmt {strcpy($<t.str>$,$<t.str>1);}
;

write_stmt: T_WRITE x1 {
char result[1000];

sprintf(result, "[WRITE%s]", $<t.str>2);
strcpy($<t.str>$,result);
}
;

x1: T_LP T_STRING T_RP {
char result[1000];
char *res=strdup($<t.str>2);
sprintf(result, "[{%s}]",$<t.str>2);
strcpy($<t.str>$,result);
}
| T_LP variable_list T_RP {strcpy($<t.str>$,$<t.str>2);

}
;

variable_list: T_ID T_COMMA variable_list {
char result[1000];
sprintf(result, "[id:{%s}]%s", $<t.str>1,$<t.str>3);
//printf("this is result of T_ID :%s\n",result);
strcpy($<t.str>$,result);
}
| T_ID {
char result[1000];
sprintf(result, "[id:{%s}]", $<t.str>1);

//printf("this is result of T_ID :%s\n",result);
strcpy($<t.str>$,result);
}
;

read_stmt: T_READ T_LP y T_RP{
    char result[1000];
    sprintf(result,"[READ%s]",$<t.str>3);
    strcpy($<t.str>$,result);
}
;

y:T_ID {char result[1000]; // Assuming a maximum length for the result string

// Concatenate strings using sprintf
sprintf(result, "[id:{%s}]", $<t.str>1);
strcpy($<t.str>$,result);}
| array_access{strcpy($<t.str>$,$<t.str>1);}
;

assign_stmt: T_ID T_ASSIGN assign_expr {
    char result[1000];
    sprintf(result,"[:=[id:{%s}]%s]",$<t.str>1,$<t.str>3);
    strcpy($<t.str>$,result);
}
;

assign_expr:T_ID{
     sprintf($<t.str>$,"[id:{%s}]",$<t.str>1);    
     }
     |
     num
     {
     sprintf($<t.str>$,"[%s]",$<t.str>1);
     }

     |

     array_access

     {

     strcpy($<t.str>$,$<t.str>1);

     }
    | T_LP assign_expr T_RP{strcpy($<t.str>$,$<t.str>2);}
    | T_MINUS assign_expr {
    char result[1000];
    sprintf(result,"[-%s]",$<t.str>1);
    strcpy($<t.str>$,result);
    
    }
    | assign_expr T_PLUS assign_expr {
        char result[1000];
	sprintf(result, "[+%s %s]", $<t.str>1, $<t.str>3);
	strcpy($<t.str>$, result);

    }
    | assign_expr  T_MINUS assign_expr {
    char result[1000];
	sprintf(result, "[-%s%s]", $<t.str>1, $<t.str>3);
	strcpy($<t.str>$, result);
    }
    | assign_expr T_MUL assign_expr {
    char result[1000];
	sprintf(result, "[*%s%s]", $<t.str>1, $<t.str>3);
	strcpy($<t.str>$, result);
    
    }
    | assign_expr T_DIV assign_expr 
    {
      char result[1000];
	sprintf(result, "[/%s%s]", $<t.str>1, $<t.str>3);
	strcpy($<t.str>$, result);
    }
    | assign_expr T_MOD assign_expr {
    char result[1000];
	sprintf(result, "[%% %s%s]", $<t.str>1, $<t.str>3);
	strcpy($<t.str>$, result);
    }
    ;
array_access: T_ID T_LB id T_RB 
{
 char result[1000]; // Assuming a maximum length for the result string

// Concatenate strings using sprintf
sprintf(result, "[numbers{%s}]", $<t.str>3);
strcpy($<t.str>$,result);


}
;


block_stmt: T_BEGIN stmt_list T_END{

sprintf($<t.str>$,"[BEGIN]%s[END]",$<t.str>2);

}
;

cond_stmt: T_IF condition T_THEN block_stmt {
	char result[1000];
	sprintf(result, "[IF2[COND%s][THEN_BODY%s]]", $<t.str>2,$<t.str>4);
	strcpy($<t.str>$, result);

}
| T_IF condition T_THEN block_stmt T_ELSE block_stmt {
	char result[1000];
	sprintf(result, "[IF1[COND%s][THEN_BODY%s][ELSE_BODY%s]]", $<t.str>2,$<t.str>4,$<t.str>6);
	strcpy($<t.str>$, result);

}
;

loop_stmt: T_WHILE condition T_DO block_stmt {
        char result[1000];
	sprintf(result, "[WHILE[COND%s][DO_BODY%s]]", $<t.str>2,$<t.str>4);
	strcpy($<t.str>$, result);
}
| T_FOR T_ID T_ASSIGN expr T_DOWNTO expr T_DO block_stmt 
{
        char result[1000];
	sprintf(result, "[FOR2[COND[=[id:{%s}]%s][DOWNTO][=[id:{%s}]%s]][BODY%s]]",   						$<t.str>2,$<t.str>4,$<t.str>2,$<t.str>6,$<t.str>8);
	strcpy($<t.str>$, result);


}
| T_FOR T_ID T_ASSIGN expr T_TO expr T_DO block_stmt 
{
   char result[1000];
	sprintf(result, "[FOR1[COND[=[id:{%s}]%s][TO][=[id:{%s}]%s]][BODY%s]]",   						$<t.str>2,$<t.str>4,$<t.str>2,$<t.str>6,$<t.str>8);
	strcpy($<t.str>$, result);
}
;

condition: boolean_expr {strcpy($<t.str>$, $<t.str>1);}
         | relational_expr {strcpy($<t.str>$, $<t.str>1);}
         ;

boolean_expr: T_ID {sprintf($<t.str>$,"[id:{%s}]",$<t.str>1);}
            | T_NOT boolean_expr {char result[1000];
	sprintf(result, "[NOT%s]", $<t.str>2);
	strcpy($<t.str>$, result);}
            | T_NOT T_LP boolean_expr T_RP {char result[1000];
	sprintf(result, "[NOT%s]", $<t.str>3);
	strcpy($<t.str>$, result);}
            | boolean_expr T_AND boolean_expr {
            char result[1000];
	sprintf(result, "[AND%s%s]", $<t.str>1, $<t.str>3);
	strcpy($<t.str>$, result);
            }
            | boolean_expr T_OR boolean_expr {
            char result[1000];
	sprintf(result, "[OR%s%s]", $<t.str>1, $<t.str>3);
	strcpy($<t.str>$, result);
            }
            ;

relational_expr: expr T_EQUAL expr {
char result[1000];
	sprintf(result, "[=%s%s]", $<t.str>1, $<t.str>3);
	strcpy($<t.str>$, result);

}
               | expr T_UNEQUAL expr 
               {
               char result[1000];
	sprintf(result, "[<>%s%s]", $<t.str>1, $<t.str>3);
	strcpy($<t.str>$, result);
               
               }
               
               | expr T_LT expr {
               
               char result[1000];
	sprintf(result, "[<%s%s]", $<t.str>1, $<t.str>3);
	strcpy($<t.str>$, result);
               }
               | expr T_GT expr 
               {
               char result[1000];
	sprintf(result, "[>%s%s]", $<t.str>1, $<t.str>3);
	strcpy($<t.str>$, result);
               
               }
               | expr T_LE expr
               
               {
               char result[1000];
	sprintf(result, "[<=%s%s]", $<t.str>1, $<t.str>3);
	strcpy($<t.str>$, result);
               }
               | expr T_GE expr 
               
               {
             char result[1000];
	sprintf(result, "[>=%s%s]", $<t.str>1, $<t.str>3);
	strcpy($<t.str>$, result);  
               
               }
               ;
               
expr: 

     T_ID{

     sprintf($<t.str>$,"[id:{%s}]",$<t.str>1);

     

     }

     |

     num

     {

     sprintf($<t.str>$,"[%s]",$<t.str>1);

     }

     |

     array_access

     {

     strcpy($<t.str>$,$<t.str>1);

     }
    | T_LP expr T_RP {strcpy($<t.str>$, $<t.str>2);}
    | T_NOT boolean_expr {
        char result[1000];
	sprintf(result, "[NOT%s]", $<t.str>2);
	strcpy($<t.str>$, result);
    
    }
    | expr T_PLUS expr {
    char result[1000];
	sprintf(result, "[+%s%s]", $<t.str>1, $<t.str>3);
	strcpy($<t.str>$, result);
    
    }
    | expr T_MINUS expr {
    char result[1000];
	sprintf(result, "[-%s%s]", $<t.str>1, $<t.str>3);
	strcpy($<t.str>$, result);
    
    }
    | expr T_MUL expr {
    char result[1000];
	sprintf(result, "[*%s%s]", $<t.str>1, $<t.str>3);
	strcpy($<t.str>$, result);
    
    }
    | expr T_DIV expr {
    char result[1000];
	sprintf(result, "[/%s%s]", $<t.str>1, $<t.str>3);
	strcpy($<t.str>$, result);
    
    }
    | expr T_MOD expr {
    char result[1000];
	sprintf(result, "[%% %s%s]", $<t.str>1, $<t.str>3);
	strcpy($<t.str>$, result);
    }
    ;

id: T_ID {

sprintf($<t.str>$,"id:{%s}",$<t.str>1);

}
    | num 
    {
    strcpy($<t.str>$,$<t.str>1);
    }
    | array_access {

strcpy($<t.str>$,$<t.str>1);
    }
    ;


%%

int main() 
{ 
    char filename[100];
    scanf("%s", filename);

    yyin = fopen(filename, "r");
    if (yyin == NULL) {
        printf("Error opening file: %s\n", filename);
        return 1;
    }
    yyparse();
    fclose(yyin);
    printSymbolTable();
    return 0;
}

void yyerror(){
    printf("Syntax error..\n");
}

