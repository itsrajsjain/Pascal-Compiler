%{
#include <stdio.h>
#include <string.h>
extern int yylex();
extern int yyparse();
extern FILE *yyin;
#define MAX_LEN 10000

// Symbol table entry structure
typedef struct {
    char name[MAX_LEN];
    char type[MAX_LEN];
    int initialized;
    
} SymbolEntry;

// Symbol table for variable declarations
SymbolEntry symbolTable[MAX_LEN];
int symbolCount = 0;

// Function to print the symbol table
void printSymbolTable() {
    printf("Symbol Table:\n");
    printf("-------------\n");
    printf("Name\t\t\tType\t\t\tInitialized\n");
    printf("----\t\t\t----\t\t\t-----------\n");
    for (int i = 0; i < symbolCount; i++) {
        printf("%s\t\t\t%s\t\t\t%s\n", symbolTable[i].name, symbolTable[i].type, symbolTable[i].initialized ? "Yes" : "No");
    }
}


// Function to check if a variable is declared
int isDeclared(char* name) {
    for (int i = 0; i < symbolCount; i++) {
        if (strcasecmp(symbolTable[i].name, name) == 0) {
            return 1; // Variable found in symbol table
        }
    }
    return 0; // Variable not found
}

// Function to add a variable to the symbol table
void addToSymbolTable(char* name, char* type) {
    strcpy(symbolTable[symbolCount].name, name);
    strcpy(symbolTable[symbolCount].type, type);
    symbolTable[symbolCount].initialized = 0; // Initialize flag to false
    symbolCount++;
}


// Function to print undeclared variable error
void printUndeclaredError(char* name) {
    printf("Error: Undeclared variable '%s'\n", name);
}

// Function to print multiple declarations error
void printMultipleDeclarationsError(char* name) {
    printf("Error: Multiple declarations of variable '%s'\n", name);
}

// Function to lookup the type of a variable in the symbol table
char* lookup_type(char* name) {
    for (int i = 0; i < symbolCount; i++) {
        if (strcasecmp(symbolTable[i].name, name) == 0) {
            return symbolTable[i].type; // Return the type if variable found
        }
    }
    return NULL; // Return NULL if variable not found
}

void set_initialized(char* name) {
    for (int i = 0; i < symbolCount; i++) {
        if (strcasecmp(symbolTable[i].name, name) == 0) {
            symbolTable[i].initialized=1; // Return the type if variable found
        }
    }
}


// Semantic action for variable declaration
void declareVariable(char* name, char* type) {
    if (isDeclared(name)) {
        printMultipleDeclarationsError(name);
    } else {
        addToSymbolTable(name, type);
    }
}

// Semantic action for identifier usage
int checkVariableUsage(char* name) {
    for (int i = 0; i < symbolCount; i++) {
        if (strcasecmp(symbolTable[i].name, name) == 0) {
            if (symbolTable[i].initialized == 0) {
                printf("Error: Variable '%s' does not seem to be initialized\n", name);
            }
            return 1; // Variable found in symbol table
        }
    }
    printUndeclaredError(name);
    return 0; // Variable not found
}

// Semantic action for identifier usage
int check_AssignVariableUsage(char* name) {
    for (int i = 0; i < symbolCount; i++) {
        if (strcasecmp(symbolTable[i].name, name) == 0) {
            return 1; // Variable found in symbol table
        }
    }
    printUndeclaredError(name);
    return 0; // Variable not found
}


// Function to check type compatibility
int checkTypeCompatibility(char* type1, char* type2,char* type3) {
    
    if(((strcasecmp(type1 , "integer")==0 && strcasecmp(type2 , "integer")==0 ))){
    	strcpy(type3,"integer");
    	return 1;
    }
    
    if(((strcasecmp(type1 , "real")==0 && strcasecmp(type2 , "real")==0 ))){
    	strcpy(type3,"real");
    	return 1;
    }
    
    if(((strcasecmp(type1 , "integer")==0 && strcasecmp(type2 , "real")==0 ))){
    	strcpy(type3,"real");
    	return 1;
    }
    
    if(((strcasecmp(type1 , "real")==0 && strcasecmp(type2 , "integer")==0 ))){
    	strcpy(type3,"real");
    	return 1;
    }
    
    return 0;
}

// Semantic action for type mismatch error
void printTypeMismatchError(char* expectedType, char* actualType) {
    printf("Error: Assignemnt Type mismatch - expected '%s', got '%s'\n", expectedType, actualType);
}

// Semantic action for assignment expression
void checkAssignmentType(char* expr1Type, char* expr2Type, char* expr3Type) {
    if (!checkTypeCompatibility(expr1Type, expr2Type, expr3Type)) {
        printTypeMismatchError(expr1Type, expr2Type);
    } else {
        // Update initialization status
        symbolTable[symbolCount - 1].initialized = 1;
    }
}

void printArrayIndexTypeMismatchError(char* expectedType, char* actualType) {
    printf("Error: Array Index Type mismatch - expected '%s', got '%s'\n", expectedType, actualType);
}

void setType(char* type) {
    // Set the type for all variables declared in the current scope
    for (int i = 0; i < symbolCount; i++) {
        if (strcmp(symbolTable[i].type, "") == 0) {
            // Set the type for variables with an empty type
            strcpy(symbolTable[i].type, type);
        }
    }
}


%}

%union{
struct{
char* type;
union{
int ival;
float fval;
//char cval;
char* sval;
}v; }t;
}

%left T_LT T_GT T_LE T_GE T_EQUAL T_UNEQUAL
%left T_PLUS T_MINUS T_OR
%left T_MUL T_DIV T_MOD T_AND
%right T_NOT

%token T_PROGRAM T_VAR
%token T_INT
%token T_REAL
%token T_ID
%token T_STRING
%token T_BEGIN T_END
%token T_READ T_WRITE
%token T_IF T_THEN T_ELSE T_WHILE T_DO T_TO T_DOWNTO T_FOR
%token T_EQUAL T_UNEQUAL T_GE T_GT T_LE T_LT T_ASSIGN T_PLUS T_MINUS T_MUL T_DIV T_OR T_AND T_NOT T_MOD
%token T_LB T_RB T_LP T_RP T_SEMI T_DOT T_DOTDOT T_COMMA T_COLON
%token T_INTEGER_TYPE T_BOOLEAN_TYPE T_CHAR_TYPE T_REAL_TYPE
%token T_ARRAY T_OF


%%

S: T_PROGRAM T_ID T_SEMI var_declaration main T_DOT {return 0;}
;

var_declaration: T_VAR var_decl_list  {}
| 
;

var_decl_list: var_decl_list var_decl {}
| var_decl {}
;

var_decl: name_list T_COLON type_dec T_SEMI {}
;

name_list: name_list T_COMMA T_ID {declareVariable($<t.v.sval>3,"");}
| T_ID {declareVariable($<t.v.sval>1,"");}
;

type_dec: type {setType($<t.type>1);}
| array_type_decl {}
;

type: T_INTEGER_TYPE {$<t.type>$=$<t.type>1;}
|T_BOOLEAN_TYPE {$<t.type>$=$<t.type>1;}
|T_CHAR_TYPE {$<t.type>$=$<t.type>1;}
|T_REAL_TYPE {$<t.type>$=$<t.type>1;}
;

array_type_decl: T_ARRAY T_LB x T_RB T_OF type {setType($<t.type>6);}
;

x: const_value T_DOTDOT const_value {} //if indexes required
;

const_value: num {$<t.type>$=$<t.type>1}
|T_MINUS num     {$<t.type>$=$<t.type>2}
;

num: T_INT {$<t.type>$=$<t.type>1;}
| T_REAL {$<t.type>$=$<t.type>1;}
;

main: T_BEGIN stmt_list T_END {}
;

stmt_list: stmt T_SEMI stmt_list {}
| stmt T_SEMI {}
;

stmt: write_stmt {}
| read_stmt {}
| assign_stmt {}
| block_stmt {}
| cond_stmt {}
| loop_stmt {}
;

write_stmt: T_WRITE x1 {}
;

x1: T_LP T_STRING T_RP {}
| T_LP variable_list T_RP {}
;

variable_list: T_ID T_COMMA variable_list {checkVariableUsage($<t.v.sval>1);}
| T_ID {checkVariableUsage($<t.v.sval>1);}
;

read_stmt: T_READ T_LP y T_RP {}
;

y:T_ID {set_initialized($<t.v.sval>1);checkVariableUsage($<t.v.sval>1);}
| array_access_read {}
;

assign_stmt: T_ID T_ASSIGN assign_expr {

	if(check_AssignVariableUsage($<t.v.sval>1)){

		if(((strcasecmp(lookup_type($<t.v.sval>1),"integer")==0 && strcasecmp($<t.type>3,"integer")==0 ))){
		  	set_initialized($<t.v.sval>1);
	    	}
	    	
	    	else if(((strcasecmp(lookup_type($<t.v.sval>1),"real")==0 && strcasecmp($<t.type>3,"real")==0 ))){
		  	set_initialized($<t.v.sval>1);
	    	}
	    	
	    	else if(((strcasecmp(lookup_type($<t.v.sval>1),"real")==0 && strcasecmp($<t.type>3,"integer")==0 ))){
		  	set_initialized($<t.v.sval>1);
	    	}
	    	
	    	else if(((strcasecmp(lookup_type($<t.v.sval>1),"char")==0 && strcasecmp($<t.type>3,"char")==0 ))){
		  	set_initialized($<t.v.sval>1);
	    	}
	    	
	    	else if(((strcasecmp(lookup_type($<t.v.sval>1),"boolean")==0 && strcasecmp($<t.type>3,"boolean")==0))){
		  	set_initialized($<t.v.sval>1);
	    	}
	    	
	    	else if(((strcasecmp($<t.type>1,"undeclared")==0||strcasecmp($<t.type>3, "undeclared")==0))){

    		}
	    	
	    	else{
	    		printTypeMismatchError(lookup_type($<t.v.sval>1), $<t.type>3);
	    	}
	}
}
;

assign_expr: id {
	$<t.type>$=$<t.type>1;
	}
    | T_LP assign_expr T_RP {$<t.type>$=$<t.type>2;}
    | T_MINUS assign_expr {$<t.type>$=$<t.type>2;}
    | assign_expr T_PLUS assign_expr {

    if(((strcasecmp($<t.type>1,"integer")==0 && strcasecmp($<t.type>3,"integer")==0 ))){
    	$<t.type>$=strdup("integer");
    }
    
    else if(((strcasecmp($<t.type>1,"integer")==0 && strcasecmp($<t.type>3,"real")==0 ))){
    	$<t.type>$=strdup("real");
    }
    
    else if(((strcasecmp($<t.type>1,"real")==0 && strcasecmp($<t.type>3,"integer")==0 ))){
    	$<t.type>$=strdup("real");
    }
    
    else if(((strcasecmp($<t.type>1 ,"real")==0 && strcasecmp($<t.type>3,"real")==0 ))){
    	$<t.type>$=strdup("real");
    }
    
    else if(((strcasecmp($<t.type>1,"undeclared")==0 || strcasecmp($<t.type>3,"undeclared")==0 ))){
    
    }
    
    else{
	printf("Error:Operand Type mismatch - '%s', got added with '%s'\n", $<t.type>1,$<t.type>3);    
    }
    
    }
    | assign_expr  T_MINUS assign_expr {
    
    if(((strcasecmp($<t.type>1 , "integer")==0 && strcasecmp($<t.type>3 , "integer")==0 ))){
    	$<t.type>$=strdup("integer");
    }
    
    else if(((strcasecmp($<t.type>1 , "integer")==0 && strcasecmp($<t.type>3 , "real")==0 ))){
    	$<t.type>$=strdup("real");
    }
    
    else if(((strcasecmp($<t.type>1 , "real")==0 && strcasecmp($<t.type>3 , "integer")==0 ))){
    	$<t.type>$=strdup("real");
    }
    
    else if(((strcasecmp($<t.type>1 , "real")==0 && strcasecmp($<t.type>3 , "real")==0 ))){
    	$<t.type>$=strdup("real");
    }
    
    else if(((strcasecmp($<t.type>1 , "undeclared")==0 || strcasecmp($<t.type>3 , "undeclared")==0 ))){
    
    }
    
    else{
	printf("Error:Operand Type mismatch - '%s', got subtracted with '%s'\n", $<t.type>1, $<t.type>3);
    }
    
    }
    | assign_expr T_MUL assign_expr {
    
    if(((strcasecmp($<t.type>1 , "integer")==0 && strcasecmp($<t.type>3 , "integer")==0 ))){
    	$<t.type>$=strdup("integer");
    }
    
    else if(((strcasecmp($<t.type>1 , "integer")==0 && strcasecmp($<t.type>3 , "real")==0 ))){
    	$<t.type>$=strdup("real");
    }
    
    else if(((strcasecmp($<t.type>1 , "real")==0 && strcasecmp($<t.type>3 , "integer")==0 ))){
    	$<t.type>$=strdup("real");
    }
    
    else if(((strcasecmp($<t.type>1 , "real")==0 && strcasecmp($<t.type>3 , "real")==0 ))){
    	$<t.type>$=strdup("real");
    }
    
    else if(((strcasecmp($<t.type>1 , "undeclared")==0 || strcasecmp($<t.type>3 , "undeclared")==0 ))){
    
    }
    
    else{
	printf("Error:Operand Type mismatch - '%s', got multiplied with '%s'\n", $<t.type>1, $<t.type>3);
    }
    
    
    }
    | assign_expr T_DIV assign_expr {
    
    if(((strcasecmp($<t.type>1 , "integer")==0 && strcasecmp($<t.type>3 , "integer")==0 ))){
    	$<t.type>$=strdup("real");
    }
    
    else if(((strcasecmp($<t.type>1 , "integer")==0 && strcasecmp($<t.type>3 , "real")==0 ))){
    	$<t.type>$=strdup("real");
    }
    
    else if(((strcasecmp($<t.type>1 , "real")==0 && strcasecmp($<t.type>3 , "integer")==0 ))){
    	$<t.type>$=strdup("real");
    }
    
    else if(((strcasecmp($<t.type>1 , "real")==0 && strcasecmp($<t.type>3 , "real")==0 ))){
    	$<t.type>$=strdup("real");
    }
    
    else if(((strcasecmp($<t.type>1 , "undeclared")==0 || strcasecmp($<t.type>3 , "undeclared")==0 ))){
    
    }
    
    else{
	printf("Error:Operand Type mismatch - '%s', got divided with '%s'\n", $<t.type>1, $<t.type>3);
    }
    
    }
    | assign_expr T_MOD assign_expr {
    
    if(((strcasecmp($<t.type>1 , "integer")==0 && strcasecmp($<t.type>3 , "integer")==0 ))){
    	$<t.type>$=strdup("integer");
    }
    
    else if(((strcasecmp($<t.type>1 , "undeclared")==0 || strcasecmp($<t.type>3 , "undeclared")==0 ))){
    
    }
    
    else{
	printf("Error:Operand Type mismatch - '%s', got mod with '%s'\n", $<t.type>1, $<t.type>3);
    }
    
    }
    ;
    
array_access: T_ID T_LB id T_RB {checkVariableUsage($<t.v.sval>1);$<t.type>$=$<t.type>1;} //Do we have we have to check array index out of bounds and is it integer value??
    ;
    
array_access_read: T_ID T_LB id T_RB {set_initialized($<t.v.sval>1);checkVariableUsage($<t.v.sval>1);$<t.type>$=$<t.type>1;} //Do we have we have to check array index out of bounds and is it integer value??
    ;


block_stmt: T_BEGIN stmt_list T_END {}
;

cond_stmt: T_IF condition T_THEN block_stmt {}
| T_IF condition T_THEN block_stmt T_ELSE block_stmt {}
;

//check after for can expr come in second prodution of loop_stmt????

loop_stmt: T_WHILE condition T_DO block_stmt {}
| T_FOR T_ID{set_initialized($<t.v.sval>2);} T_ASSIGN expr a expr T_DO block_stmt {checkVariableUsage($<t.v.sval>2);}
;

condition: boolean_expr {$<t.type>$=$<t.type>1;}
         | relational_expr {$<t.type>$=$<t.type>1;}
         ;

boolean_expr: boolean_value {

	if(((strcasecmp($<t.type>1 , "boolean")==0))){
    			$<t.type>$=$<t.type>1;
    	}
    	
    	else if(((strcasecmp($<t.type>1 , "undeclared")==0))){
    			$<t.type>$=$<t.type>1;
    	}
    	
    	else{
    	printf("Error: Incompatible Types - expected boolean, got '%s'\n", $<t.type>1);
    			$<t.type>$=$<t.type>1;
    	}
}
            | T_NOT boolean_expr {$<t.type>$=$<t.type>2;}
            | T_NOT T_LP boolean_expr T_RP {$<t.type>$=$<t.type>3;}
            | boolean_expr T_AND boolean_expr 
            {
            	if(((strcasecmp($<t.type>1 , "boolean")==0 && strcasecmp($<t.type>3 , "boolean")==0 ))){
    			$<t.type>$=$<t.type>1;
    		}
    		
    		
    		else if(((strcasecmp($<t.type>1 ,"undeclared")==0||strcasecmp($<t.type>3, "undeclared")==0))){
    			$<t.type>$=strdup("undeclared");
    		}
    		
    		else{
    		
    		printf("Error: AND Operation Type mismatch - '%s', and '%s'\n",$<t.type>1,$<t.type>3);
    		
    		}
            		
            	
            }
            | boolean_expr T_OR boolean_expr 
            {
            
            if(((strcasecmp($<t.type>1 ,"boolean")==0 && strcasecmp($<t.type>3 ,"boolean")==0 ))){
    			$<t.type>$=$<t.type>1;
    		}
    		
    		
    		else if(((strcasecmp($<t.type>1 ,"undeclared")==0||strcasecmp($<t.type>3, "undeclared")==0))){
    			$<t.type>$=strdup("undeclared");
    		}
    		
    		else{
    		
    		printf("Error: OR Operation Type mismatch - '%s', and '%s'\n",$<t.type>1,$<t.type>3);
    		
    		}
            
            }
            ;

boolean_value:T_ID {
	if(checkVariableUsage($<t.v.sval>1)){
		$<t.type>$=lookup_type($<t.v.sval>1);
	}
	else $<t.type>$=strdup("undeclared");
}
;
relational_expr: expr T_EQUAL expr {
	 if(strcasecmp($<t.type>1,$<t.type>3)==0){
	     $<t.type>$=$<t.type>1;
	 }
	 else if(((strcasecmp($<t.type>1,"integer")==0 && strcasecmp($<t.type>3,"real")==0 ))){
	    	$<t.type>$=strdup("real");
	    }
	 else if(((strcasecmp($<t.type>1,"real")==0 && strcasecmp($<t.type>3,"integer")==0 ))){
	    	$<t.type>$=strdup("real");
	    }
	 else if(((strcasecmp($<t.type>1,"undeclared")==0 || strcasecmp($<t.type>3,"undeclared")==0 ))){
    
    	}   
	 else{
		printf("Error:Relational Operand Type mismatch - '%s', got compared with '%s'\n", $<t.type>1,$<t.type>3);    
	    }


}
      | expr T_UNEQUAL expr {
	if(strcasecmp($<t.type>1,$<t.type>3)==0){
	     $<t.type>$=$<t.type>1;
	 }
	else if(((strcasecmp($<t.type>1,"integer")==0 && strcasecmp($<t.type>3,"real")==0 ))){
	    	$<t.type>$=strdup("real");
	    }
	else if(((strcasecmp($<t.type>1,"real")==0 && strcasecmp($<t.type>3,"integer")==0 ))){
	    	$<t.type>$=strdup("real");
	    }
	else if(((strcasecmp($<t.type>1,"undeclared")==0 || strcasecmp($<t.type>3,"undeclared")==0 ))){
    
    	}    
	else{
		printf("Error:Relational Operand Type mismatch - '%s', got compared with '%s'\n", $<t.type>1,$<t.type>3);    
	    }           

               
               }
    | expr T_LT expr {
    
	if(strcasecmp($<t.type>1,$<t.type>3)==0){
	     $<t.type>$=$<t.type>1;
	 }
	 else if(((strcasecmp($<t.type>1,"integer")==0 && strcasecmp($<t.type>3,"real")==0 ))){
	    	$<t.type>$=strdup("real");
	    }
	 else if(((strcasecmp($<t.type>1,"real")==0 && strcasecmp($<t.type>3,"integer")==0 ))){
	    	$<t.type>$=strdup("real");
	    }
	 else if(((strcasecmp($<t.type>1,"undeclared")==0 || strcasecmp($<t.type>3,"undeclared")==0 ))){
    
    	}   
	 else{
		printf("Error:Relational Operand Type mismatch - '%s', got compared with '%s'\n", $<t.type>1,$<t.type>3);    
	    }  
		       }
               
               
    | expr T_GT expr {
		if(strcasecmp($<t.type>1,$<t.type>3)==0){
		     $<t.type>$=$<t.type>1;
		 }
		 else if(((strcasecmp($<t.type>1,"integer")==0 && strcasecmp($<t.type>3,"real")==0 ))){
		    	$<t.type>$=strdup("real");
		    }
		 else if(((strcasecmp($<t.type>1,"real")==0 && strcasecmp($<t.type>3,"integer")==0 ))){
		    	$<t.type>$=strdup("real");
		    }
		 else if(((strcasecmp($<t.type>1,"undeclared")==0||strcasecmp($<t.type>3,"undeclared")==0))){
    
    		}  
		 else{
			printf("Error:Relational Operand Type mismatch - '%s', got compared with '%s'\n", $<t.type>1,$<t.type>3);    
		    }             
               }
    | expr T_LE expr {
		if(strcasecmp($<t.type>1,$<t.type>3)==0){
		     $<t.type>$=$<t.type>1;
		 }
		 else if(((strcasecmp($<t.type>1,"integer")==0 && strcasecmp($<t.type>3,"real")==0 ))){
		    	$<t.type>$=strdup("real");
		    }
		 else if(((strcasecmp($<t.type>1,"real")==0 && strcasecmp($<t.type>3,"integer")==0 ))){
		    	$<t.type>$=strdup("real");
		    }
		 else if(((strcasecmp($<t.type>1,"undeclared")==0||strcasecmp($<t.type>3,"undeclared")==0))){
    
    		 }    
		 else{
			printf("Error:Relational Operand Type mismatch - '%s', got compared with '%s'\n", $<t.type>1,$<t.type>3);    
		    }
    
    
    
    }
    | expr T_GE expr {
		if(strcasecmp($<t.type>1,$<t.type>3)==0){
		     $<t.type>$=$<t.type>1;
		 }
		 else if(((strcasecmp($<t.type>1,"integer")==0 && strcasecmp($<t.type>3,"real")==0 ))){
		    	$<t.type>$=strdup("real");
		    }
		 else if(((strcasecmp($<t.type>1,"real")==0 && strcasecmp($<t.type>3,"integer")==0 ))){
		    	$<t.type>$=strdup("real");
		    }
		 else if(((strcasecmp($<t.type>1,"undeclared")==0||strcasecmp($<t.type>3,"undeclared")==0))){
    
    		 }    
		 else{
			printf("Error:Relational Operand Type mismatch - '%s', got compared with '%s'\n", $<t.type>1,$<t.type>3);    
		    }   
    
    }
               ;
               
expr: id {$<t.type>$=$<t.type>1;}
    | T_LP expr T_RP {$<t.type>$=$<t.type>2;}
    | unary_expr {$<t.type>$=$<t.type>1;}
    | expr T_PLUS expr {
    
    if(((strcasecmp($<t.type>1,"integer")==0 && strcasecmp($<t.type>3,"integer")==0 ))){
    	$<t.type>$=strdup("integer");
    }
    
    else if(((strcasecmp($<t.type>1,"integer")==0 && strcasecmp($<t.type>3,"real")==0 ))){
    	$<t.type>$=strdup("real");
    }
    
    else if(((strcasecmp($<t.type>1,"real")==0 && strcasecmp($<t.type>3,"integer")==0 ))){
    	$<t.type>$=strdup("real");
    }
    
    else if(((strcasecmp($<t.type>1 ,"real")==0 && strcasecmp($<t.type>3,"real")==0 ))){
    	$<t.type>$=strdup("real");
    }
    
    else if(((strcasecmp($<t.type>1,"undeclared")==0 || strcasecmp($<t.type>3,"undeclared")==0 ))){
    
    }
    
    else{
	printf("Error:Operand Type mismatch - '%s', got added with '%s'\n", $<t.type>1,$<t.type>3);    
    }
    
    
    }
    | expr T_MINUS expr {
    
    if(((strcasecmp($<t.type>1 , "integer")==0 && strcasecmp($<t.type>3 , "integer")==0 ))){
    	$<t.type>$=strdup("integer");
    }
    
    else if(((strcasecmp($<t.type>1 , "integer")==0 && strcasecmp($<t.type>3 , "real")==0 ))){
    	$<t.type>$=strdup("real");
    }
    
    else if(((strcasecmp($<t.type>1 , "real")==0 && strcasecmp($<t.type>3 , "integer")==0 ))){
    	$<t.type>$=strdup("real");
    }
    
    else if(((strcasecmp($<t.type>1 , "real")==0 && strcasecmp($<t.type>3 , "real")==0 ))){
    	$<t.type>$=strdup("real");
    }
    
    else if(((strcasecmp($<t.type>1 , "undeclared")==0 || strcasecmp($<t.type>3 , "undeclared")==0 ))){
    
    }
    
    else{
	printf("Error:Operand Type mismatch - '%s', got subtracted with '%s'\n", $<t.type>1, $<t.type>3);
    }
    
    }
    | expr T_MUL expr {
    
    if(((strcasecmp($<t.type>1 , "integer")==0 && strcasecmp($<t.type>3 , "integer")==0 ))){
    	$<t.type>$=strdup("integer");
    }
    
    else if(((strcasecmp($<t.type>1 , "integer")==0 && strcasecmp($<t.type>3 , "real")==0 ))){
    	$<t.type>$=strdup("real");
    }
    
    else if(((strcasecmp($<t.type>1 , "real")==0 && strcasecmp($<t.type>3 , "integer")==0 ))){
    	$<t.type>$=strdup("real");
    }
    
    else if(((strcasecmp($<t.type>1 , "real")==0 && strcasecmp($<t.type>3 , "real")==0 ))){
    	$<t.type>$=strdup("real");
    }
    
    else if(((strcasecmp($<t.type>1 , "undeclared")==0 || strcasecmp($<t.type>3 , "undeclared")==0 ))){
    
    }
    
    else{
	printf("Error:Operand Type mismatch - '%s', got multiplied with '%s'\n", $<t.type>1, $<t.type>3);
    }
    
    
    }
    | expr T_DIV expr {
    
    if(((strcasecmp($<t.type>1 , "integer")==0 && strcasecmp($<t.type>3 , "integer")==0 ))){
    	$<t.type>$=strdup("real");
    }
    
    else if(((strcasecmp($<t.type>1 , "integer")==0 && strcasecmp($<t.type>3 , "real")==0 ))){
    	$<t.type>$=strdup("real");
    }
    
    else if(((strcasecmp($<t.type>1 , "real")==0 && strcasecmp($<t.type>3 , "integer")==0 ))){
    	$<t.type>$=strdup("real");
    }
    
    else if(((strcasecmp($<t.type>1 , "real")==0 && strcasecmp($<t.type>3 , "real")==0 ))){
    	$<t.type>$=strdup("real");
    }
    
    else if(((strcasecmp($<t.type>1 , "undeclared")==0 || strcasecmp($<t.type>3 , "undeclared")==0 ))){
    
    }
    
    else{
	printf("Error:Operand Type mismatch - '%s', got divided with '%s'\n", $<t.type>1, $<t.type>3);
    }
    
    }
    | expr T_MOD expr {
    
    if(((strcasecmp($<t.type>1 , "integer")==0 && strcasecmp($<t.type>3 , "integer")==0 ))){
    	$<t.type>$=strdup("integer");
    }
    
    else if(((strcasecmp($<t.type>1 , "undeclared")==0 || strcasecmp($<t.type>3 , "undeclared")==0 ))){
    
    }
    
    else{
	printf("Error:Operand Type mismatch - '%s', got mod with '%s'\n", $<t.type>1, $<t.type>3);
    }
    
    }
    ;
    
unary_expr: T_NOT boolean_expr {$<t.type>$=$<t.type>2;}
| T_MINUS expr {$<t.type>$=$<t.type>2;}
;

id: T_ID {
	if(checkVariableUsage($<t.v.sval>1)){
	$<t.type>$=lookup_type($<t.v.sval>1);
	}
	else $<t.type>$=strdup("undeclared");
}
    | num {$<t.type>$=$<t.type>1;}
    | array_access {$<t.type>$=$<t.type>1;}
;

a: T_TO {}
| T_DOWNTO {}
;
%%

int main() 
{ 
    char filename[100];
    printf("Enter input file name: ");
    scanf("%s", filename);
    yyin = fopen(filename, "r");
    yyparse();
    fclose(yyin);
    return 0;
}

// Function to handle syntax errors
void yyerror(char *s) {
    printf("Syntax error: %s\n", s);
}
