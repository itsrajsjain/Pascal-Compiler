%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
extern int yylex();
extern int yyparse();
extern FILE *yyin;
int n=0;
int labelCount=0;
%}

%union{
struct t{
char* code;
char str[1000];
union{
int ival;
float fval;
}v;}t;
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

%%


S: T_PROGRAM T_ID T_SEMI var_declaration main T_DOT 
{
        printf("%s",$<t.code>5);
        return 0;
}
;

var_declaration: T_VAR var_decl_list {}
| {}
;

var_decl_list: var_decl_list var_decl
| var_decl
;

var_decl: name_list T_COLON type_dec T_SEMI
;

name_list: name_list T_COMMA T_ID
| T_ID
;

type_dec: type
| array_type_decl
;

type: T_INTEGER_TYPE
|T_BOOLEAN_TYPE
|T_CHAR_TYPE
|T_REAL_TYPE
;

array_type_decl: T_ARRAY T_LB x T_RB T_OF type
;

x: const_value T_DOTDOT const_value
;

const_value: num|T_MINUS num
;

main: T_BEGIN stmt_list T_END {$<t.code>$=$<t.code>2;}
;

stmt_list: stmt T_SEMI stmt_list{handle_stmt(&$$,$1,$3);}
| stmt T_SEMI {$<t.code>$=$<t.code>1;}
;

stmt: write_stmt {$<t.code>$=$<t.code>1;}
| read_stmt {$<t.code>$=$<t.code>1;}
| assign_stmt {$<t.code>$=$<t.code>1;}
| block_stmt{$<t.code>$=$<t.code>1;}
| cond_stmt {$<t.code>$=$<t.code>1;}
| loop_stmt {$<t.code>$=$<t.code>1;}
;

write_stmt: T_WRITE x1 {$<t.code>$=$<t.code>2;strcpy($<t.str>$,$<t.str>2);}
;

x1: T_LP T_STRING T_RP {write_3ac_type1(&$$,$2);}
| T_LP variable_list T_RP {write_3ac_type2(&$$,$2);}
;

variable_list: T_ID T_COMMA variable_list {handle_variable_3ac(&$$,$1,$3);}
| T_ID {strcpy($<t.str>$,$<t.str>1);}
;

read_stmt: T_READ T_LP y T_RP {read_3ac(&$$,$3);}
;

y:T_ID {strcpy($<t.str>$,$<t.str>1);}
| array_access {$<t.code>$=$<t.code>1;strcpy($<t.str>$,$<t.str>1);}
;

assign_stmt: T_ID T_ASSIGN assign_expr {assign_stmt_3ac(&$$,$1,$3);}
;

assign_expr: id {strcpy($<t.str>$,$<t.str>1);$<t.code>$=$<t.code>1;}
    | T_LP assign_expr T_RP {strcpy($<t.str>$,$<t.str>2);
      $<t.code>$=$<t.code>2;
    }
    | T_MINUS assign_expr {strcpy($<t.str>$,$<t.str>2);}
    | assign_expr T_PLUS assign_expr {assign_expr_3ac(&$$,$1,$3,"+");}
    | assign_expr  T_MINUS assign_expr {assign_expr_3ac(&$$,$1,$3,"-");}
    | assign_expr T_MUL assign_expr {assign_expr_3ac(&$$,$1,$3,"*");}
    | assign_expr T_DIV assign_expr {assign_expr_3ac(&$$,$1,$3,"/");}
    | assign_expr T_MOD assign_expr {assign_expr_3ac(&$$,$1,$3,"%");}
    ;
array_access: T_ID T_LB id T_RB {array_access_3ac(&$$,$1,$3)}
    ;


block_stmt: T_BEGIN stmt_list T_END{$<t.code>$=$<t.code>2;}
;

cond_stmt: T_IF condition T_THEN block_stmt {if_3ac(&$$,$2,$4);}
| T_IF condition T_THEN block_stmt T_ELSE block_stmt {if_else_3ac(&$$,$2,$4,$6);}
;

loop_stmt: T_WHILE condition T_DO block_stmt {while_3ac(&$$,$2,$4);}
| T_FOR T_ID T_ASSIGN expr T_DOWNTO expr T_DO block_stmt {for_downto_3ac(&$$,$2,$4,$6,$8);}
| T_FOR T_ID T_ASSIGN expr T_TO expr T_DO block_stmt {for_to_3ac(&$$,$2,$4,$6,$8);}
;

condition: boolean_expr {strcpy($<t.str>$,$<t.str>1); $<t.code>$=$<t.code>1;}
         | relational_expr {strcpy($<t.str>$,$<t.str>1); $<t.code>$=$<t.code>1;}
         ;

boolean_expr: T_ID {strcpy($<t.str>$,$<t.str>1);}
            | T_NOT boolean_expr {not_3ac(&$$,$2);}
            | T_NOT T_LP boolean_expr T_RP {not_3ac(&$$,$3);}
            | boolean_expr T_AND boolean_expr {conditional_3ac(&$$,$1,$3,"AND");}
            | boolean_expr T_OR boolean_expr {conditional_3ac(&$$,$1,$3,"OR");}
            ;

relational_expr: expr T_EQUAL expr {conditional_3ac(&$$,$1,$3,"=");}
               | expr T_UNEQUAL expr {conditional_3ac(&$$,$1,$3,"<>");}
               | expr T_LT expr {conditional_3ac(&$$,$1,$3,"<");}
               | expr T_GT expr {conditional_3ac(&$$,$1,$3,">");}
               | expr T_LE expr {conditional_3ac(&$$,$1,$3,"<=");}
               | expr T_GE expr {conditional_3ac(&$$,$1,$3,">=");}
               ;
               
expr: id {strcpy($<t.str>$,$<t.str>1);$<t.code>$=$<t.code>1;}
    | T_LP expr T_RP {strcpy($<t.str>$,$<t.str>2); $<t.code>$=$<t.code>2;}
    | T_NOT boolean_expr {not_3ac(&$$,$2);}
    | expr T_PLUS expr {assign_expr_3ac(&$$,$1,$3,"+");}
    | expr T_MINUS expr {assign_expr_3ac(&$$,$1,$3,"-");}
    | expr T_MUL expr {assign_expr_3ac(&$$,$1,$3,"*");}
    | expr T_DIV expr {assign_expr_3ac(&$$,$1,$3,"/");}
    | expr T_MOD expr {assign_expr_3ac(&$$,$1,$3,"%");}
    ;

id: T_ID {strcpy($<t.str>$,$<t.str>1);}
    | num {strcpy($<t.str>$,$<t.str>1);}
    | array_access {$<t.code>$=$<t.code>1;strcpy($<t.str>$,$<t.str>1);}
    ;

num: T_INT {sprintf($<t.str>$, "%d", $<t.v.ival>1);}
| T_REAL {sprintf($<t.str>$, "%f", $<t.v.fval>1);}
;

%%

char* newLabel() {
    char* label = (char*) malloc(10);
    sprintf(label, "L%d", labelCount++);
    return label;
}

void handle_variable_3ac(struct t* $$,struct t $1,struct t $3){
char *result=calloc(200,sizeof(char));
strcat(result,$1.str);
strcat(result,",");
strcat(result,$3.str);
strcpy($$->str,result);
  
}
void write_3ac_type1(struct t* $$,struct t $2){
	char *result=calloc(200,sizeof(char));
	    sprintf(result,"write(%s)\n",$2.str);
	    $$->code=result;
}

void write_3ac_type2(struct t* $$,struct t $2){
	char *result=calloc(200,sizeof(char));
                if($2.code!=NULL)
    		strcat(result,$2.code);
    		sprintf(result,"write(%s)\n",$2.str);
    		$$->code=result;
}

void read_3ac(struct t* $$, struct t $3) {
    int len = ($3.code != NULL) ? strlen($3.code) : 0;
    size_t total_length = len + strlen($3.str) + 7; // 7 is for "read()" and "\n"
    char *st = calloc(total_length, sizeof(char));
    sprintf(st, "read(%s)\n", $3.str);
    char *result = calloc(total_length, sizeof(char));
    if ($3.code != NULL)
        strcat(result, $3.code);
    strcat(result, st);
    $$->code = result;
    free(st);
}

void for_to_3ac(struct t* $$, struct t $2, struct t $4, struct t $6, struct t $8) {
    char *beginl = newLabel();
    char *endl = newLabel();
    int len1 = ($2.code != NULL) ? strlen($2.code) : 0;
    int len2 = ($4.code != NULL) ? strlen($4.code) : 0;
    int len3 = ($6.code != NULL) ? strlen($6.code) : 0;
    int len4 = ($8.code != NULL) ? strlen($8.code) : 0;
    size_t total_length = len1 + len2 + len3 + len4 + strlen(beginl) + strlen(endl) + 85; // 85 is for the additional characters needed
    char *result = calloc(total_length, sizeof(char));
    if ($2.code != NULL)
        strcat(result, $2.code);
    if ($4.code != NULL)
        strcat(result, $4.code);
    if ($6.code != NULL)
        strcat(result, $6.code);
    char *st = calloc(total_length, sizeof(char));
    sprintf(st, "%s=%s\n%s:\nif(%s>%s) goto %s\n%sgoto %s\n%s:\n",
             $2.str, $4.str, beginl, $2.str, $6.str, endl, $8.code, beginl, endl);
    strcat(result, st);
    $$->code = result;
    free(st);
}



void for_downto_3ac(struct t* $$, struct t $2, struct t $4, struct t $6, struct t $8) {
    char *beginl = newLabel();
    char *endl = newLabel();
    int len1 = ($2.code != NULL) ? strlen($2.code) : 0;
    int len2 = ($4.code != NULL) ? strlen($4.code) : 0;
    int len3 = ($6.code != NULL) ? strlen($6.code) : 0;
    int len4 = ($8.code != NULL) ? strlen($8.code) : 0;
    size_t total_length = len1 + len2 + len3 + len4 + strlen(beginl) + strlen(endl) + 85; // Adjust as needed
    char *result = calloc(total_length, sizeof(char));
    if ($2.code != NULL)
        strcat(result, $2.code);
    if ($4.code != NULL)
        strcat(result, $4.code);
    if ($6.code != NULL)
        strcat(result, $6.code);
    char *st = calloc(total_length, sizeof(char));
    sprintf(st, "%s=%s\n%s:\nif(%s<%s) goto %s\n%sgoto %s\n%s:\n",
            $2.str, $4.str, beginl, $2.str, $6.str, endl, $8.code, beginl, endl);
    strcat(result, st);
    $$->code = result;
    free(st);
}



void while_3ac(struct t* $$, struct t $2, struct t $4) {
    int len1 = ($2.code != NULL) ? strlen($2.code) : 0;
    int len2 = ($4.code != NULL) ? strlen($4.code) : 0;
    char *beginl = newLabel();
    char *endl = newLabel();
    char *st = calloc(200 + len2 + len1, sizeof(char));
    if (len1 != 0)
        sprintf(st, "%s:\n%sif(NOT %s) goto %s\n%sgoto %s\n%s:\n",
                beginl, $2.code, $2.str, endl, $4.code, beginl, endl);
    else
        sprintf(st, "%s:\nif(NOT %s) goto %s\n%sgoto %s\n%s:\n",
                beginl, $2.str, endl, $4.code, beginl, endl);
    $$->code = st;
}

void if_else_3ac(struct t* $$, struct t $2, struct t $4, struct t $6) {
    int len1 = ($2.code != NULL) ? strlen($2.code) : 0;
    int len2 = ($4.code != NULL) ? strlen($4.code) : 0;
    int len3 = ($6.code != NULL) ? strlen($6.code) : 0;
    char *truel = newLabel();
    char *endl = newLabel();
    char *st = calloc(200 + len3 + len2, sizeof(char));
    sprintf(st, "if(%s) goto %s\n%s\ngoto %s\n%s:\n%s\n%s:\n",
            $2.str, truel, $6.code, endl, truel, $4.code, endl);
    char *result = calloc(len1 + strlen(st) + 1, sizeof(char));
    if ($2.code != NULL)
        strcat(result, $2.code);
    strcat(result, st);
    $$->code = result;
    free(st);
}

void if_3ac(struct t* $$, struct t $2, struct t $4) {
    int len1 = ($2.code != NULL) ? strlen($2.code) : 0;
    int len2 = ($4.code != NULL) ? strlen($4.code) : 0;
    char *endl = newLabel();
    char *st = calloc(200 + len2, sizeof(char));
    sprintf(st, "if(NOT %s) goto %s\n%s%s:\n",
            $2.str, endl, $4.code, endl);
    char *result = calloc(len1 + strlen(st) + 1, sizeof(char));
    if ($2.code != NULL)
        strcat(result, $2.code);
    strcat(result, st);
    $$->code = result;
    free(st);
}

void conditional_3ac(struct t* $$, struct t $1, struct t $3, char *s) {
    char *truel = newLabel();
    char *endl = newLabel();
    char *st = calloc(200, sizeof(char));
    sprintf($$->str, "t%d", n);
    sprintf(st, "if(%s %s %s) goto %s\nt%d=0 \ngoto %s\n%s:\nt%d = 1 \n%s:\n",
            $1.str, s, $3.str, truel, n, endl, truel, n, endl);
    n++;
    int len1 = ($1.code != NULL) ? strlen($1.code) : 0;
    int len2 = ($3.code != NULL) ? strlen($3.code) : 0;
    char *result = calloc(len1 + len2 + strlen(st) + 1, sizeof(char));
    if ($1.code != NULL)
        strcat(result, $1.code);
    if ($3.code != NULL)
        strcat(result, $3.code);
    strcat(result, st);
    $$->code = result;
    free(st);
}

void not_3ac(struct t* $$, struct t $1) {
    char *truel = newLabel();
    char *endl = newLabel();
    char *st = calloc(200, sizeof(char));
    sprintf($$->str, "t%d", n);
    sprintf(st, "if(NOT %s) goto %s\nt%d=0 \ngoto %s\n%s:\nt%d = 1 \n%s:\n",
            $1.str, truel, n, endl, truel, n, endl);
    n++;
    int len1 = ($1.code != NULL) ? strlen($1.code) : 0;
    char *result = calloc(len1 + strlen(st) + 1, sizeof(char));
    if ($1.code != NULL)
        strcat(result, $1.code);
    strcat(result, st);
    $$->code = result;
    free(st);
}

void assign_expr_3ac(struct t* $$, struct t $1, struct t $3, char *op) {
    // Format the temporary variable name
    sprintf($$->str,"t%d", n);
    n++;
    // Build the arithmetic statement
    char *st = calloc(50, sizeof(char));
    strcat(st, $$->str);
    strcat(st, "=");
    strcat(st, $1.str);
    strcat(st, op);
    strcat(st, $3.str);
    strcat(st, "\n");
    // Calculate the total length needed for the result
    int len1 = ($1.code != NULL) ? strlen($1.code) : 0;
    int len2 = ($3.code != NULL) ? strlen($3.code) : 0;
    char *result = calloc(len1 + len2 + strlen(st) + 1, sizeof(char));
    // Concatenate existing code and the new statement
    if ($1.code != NULL)
        strcat(result, $1.code);
    if ($3.code != NULL)
        strcat(result, $3.code);
    strcat(result, st);
    // Assign the new code to lhs and free temporary string
    $$->code = result;
    free(st);
}


void assign_stmt_3ac(struct t* $$, struct t $1, struct t $3) {
    char *st = calloc(50, sizeof(char));
    strcat(st, $1.str);
    strcat(st, "=");
    strcat(st, $3.str);
    strcat(st, "\n");
    int len2 = ($3.code != NULL) ? strlen($3.code) : 0;
    char *result = calloc(len2 + strlen(st) + 1, sizeof(char));
    if ($3.code != NULL)
        strcat(result, $3.code);
    strcat(result, st);
    // Assign the new code to lhs and free temporary string
    $$->code = result;
    free(st);
}

void handle_stmt(struct t* $$, struct t $1, struct t $2) {
    int len1 = ($1.code != NULL) ? strlen($1.code) : 0;
    int len2 = ($2.code != NULL) ? strlen($2.code) : 0;
    char *result = calloc(len1 + len2 + 1, sizeof(char));
    if ($1.code != NULL)
        strcat(result, $1.code);
    if ($2.code != NULL)
        strcat(result, $2.code);
    $$->code = result;
}

void array_access_3ac(struct t* $$, struct t $1, struct t $3) {
    sprintf($$->str, "t%d", n);
    n++;
    char *st = calloc(50, sizeof(char));
    strcat(st, $$->str);
    strcat(st, "=");
    strcat(st, $1.str);
    strcat(st, "[");
    strcat(st, $3.str);
    strcat(st, "]");
    strcat(st, "\n");
    int len2 = ($3.code != NULL) ? strlen($3.code) : 0;
    char *result = calloc(len2 + strlen(st) + 1, sizeof(char));
    if ($3.code != NULL)
        strcat(result, $3.code);
    strcat(result, st);
    $$->code = result;
    free(st);
}

int main() 
{ 
    char filename[100];
    printf("Enter input file name: ");
    scanf("%s", filename);

    yyin = fopen(filename, "r");
    if (yyin == NULL) {
        printf("Error opening file: %s\n", filename);
        return 1;
    }

    yyparse();
    
    fclose(yyin);
    return 0;
}

void yyerror(){
printf("Syntax error..\n");
}
