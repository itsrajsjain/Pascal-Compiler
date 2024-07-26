#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <limits.h>
#include <stdbool.h>
#include "rough.h"

SymbolEntry symbolTable[MAX_LEN];
int symbolCount = 0;

struct StackNode* newStack(TreeNode* data)
{
    struct StackNode* stackNode = 
      (struct StackNode*)
      malloc(sizeof(struct StackNode));
    stackNode->data = data;
    stackNode->next = NULL;
    return stackNode;
}

int isEmpty(struct StackNode* root)
{
    return !root;
}

void push(struct StackNode** root, TreeNode* data)
{
    struct StackNode* stackNode = newStack(data);
    stackNode->next = *root;
    *root = stackNode;
    //printf("%s pushed to stack\n", data->value);
}

TreeNode* pop(struct StackNode** root)
{
    if (isEmpty(*root))
        return NULL;
    struct StackNode* temp = *root;
    *root = (*root)->next;
    TreeNode * popped = temp->data;
    free(temp);

    return popped;
}

TreeNode * peek(struct StackNode* root)
{
    if (isEmpty(root))
        return NULL;
    return root->data;
}


// Function to create a new TreeNode
TreeNode* createNode(char* value) {
    TreeNode* tempNode = (TreeNode*)malloc(sizeof(TreeNode));
    tempNode->value = value;
    
    return tempNode;
}

// Function to add a child TreeNode to a parent TreeNode
void addChild(TreeNode* parent, TreeNode* child) {
    int i = 0;
    while (parent->children[i] != NULL) {
        i++;
    }
    if (parent != NULL && child != NULL) {
        parent->children[i] = child;
    }
}

// Function to print the syntax tree (inorder traversal)
void printTree(TreeNode* root) {
    if (root == NULL) {
        return;
    }
    printf("(%s) [ \n",root->value);
    for (int i = 0; root->children[i]!=NULL; i++) {
        printTree(root->children[i]);
    }
    printf("]\n");
}


TreeNode* createTree(char* str) {
    struct StackNode* root = NULL;
    TreeNode* tree=NULL;
    for(int i=0;i<strlen(str);)
    {
        if(str[i]=='[')
        {
            i++;
            char* word;
            int start =i;
            
            while(str[i]!='[' && str[i]!=']')
            {
                i++;
            }
            word = (char *)malloc(i - start+1);
            word[i - start] = '\0'; 
            strncpy(word, str + start, i - start);
            push(&root, createNode(word));
        }
        else if(str[i]==']')
        {
            TreeNode* wordd=pop(&root);
            if(peek(root)!=NULL){
            addChild(peek(root),wordd);
            }
            else{
                tree = wordd;
            }
            i++;
        }
        else{
            i++;
        }
    }
   // printTree(tree);
    return tree;
}

//symbol table functions 
// Function to print the symbol table
void printSymbolTable() {
    printf("Symbol Table:\n");
    printf("-------------\n");
    printf("Name\t\t\tType\t\t\tvalue\n");
    printf("----\t\t\t----\t\t\t-----------\n");
    for (int i = 0; i < symbolCount; i++) {
    	if(strcasecmp(symbolTable[i].type,"Integer")==0)
    	{
    		printf("%s\t\t\t%s\t\t\t%d\n", symbolTable[i].name, symbolTable[i].type, symbolTable[i].value.ival);
    	}
    	else
    	{printf("%s\t\t\t%s\t\t\t%f\n", symbolTable[i].name, symbolTable[i].type, symbolTable[i].value.fval);}
       
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

float lookup_value(char* name) {
    for (int i = 0; i < symbolCount; i++) {
        if (strcasecmp(symbolTable[i].name, name) == 0) {
            if (strcasecmp(symbolTable[i].type, "Integer") == 0) {
            	return symbolTable[i].value.ival;
            }       
            else{
            	return symbolTable[i].value.fval;
            }
        }
    }
    return 0.0; // Return NULL if variable not found
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

void setarraytype(char* type) {
    // Set the type for all variables declared in the current scope
    char *name;
    
    
    int j=2;
    for(int i=0;i<symbolCount;i++){
        if (strcmp(symbolTable[i].type, "") == 0) {
            // Set the type for variables with an empty type
            strcpy(symbolTable[i].type, type);
            
            name=strdup(symbolTable[i].name);
            
            strcat(symbolTable[i].name,"[1]");
            
            break;
        }
    }
    for (int i = 0; i < symbolCount; i++) {
        if (strcmp(symbolTable[i].type, "") == 0) {
            // Set the type for variables with an empty type
            strcpy(symbolTable[i].type, type);
            char *tempname=strdup(name);
            char* index;
            sprintf(index,"[%d]",j);
            j++;
            strcat(tempname,index);                      
            strcpy(symbolTable[i].name, tempname);
        }
    }
}


void setValue(char * name, float value) {
    // Set the type for all variables declared in the current scope
    for (int i = 0; i < symbolCount; i++) {
        if (strcmp(symbolTable[i].name, name) == 0) {
            if (strcasecmp(symbolTable[i].type, "Integer") == 0) {
            	symbolTable[i].value.ival=(int)value;
            }       
            else{
            	symbolTable[i].value.fval=value;
            }       
        }
    }
}

void assignment(TreeNode * root)
{
	float answer = evaluateExpression(root->children[1]);
	char* a = root->children[0]->value;
	for(int i=0;i<strlen(a);)
		    {
			if(a[i]=='{')
			{
			    i++;
			    char* word;
			    int start=i;
			    
			    while(a[i]!='}')
			    {
				i++;
			    }
			    word = (char *)malloc(i - start+1);
			    word[i - start] = '\0'; 
			    strncpy(word, a + start, i - start);
			    return setValue(word,answer);
		
			}			
			else{
			    i++;
			}
		   }

}
float evaluateExpression(TreeNode * root)
{
	if(root==NULL)
	{return 0.0;}
	char* a = root->value;
	int p=0;
		for(int j=0;j<strlen(a);j++)
		{
			if(a[j]=='{')
			{
				p++;
			}			
		}
	if(strcmp(a,"+")==0){
		return (evaluateExpression(root->children[0])+evaluateExpression(root->children[1]));
	}
	else if(strcmp(a,"-")==0){
		return (evaluateExpression(root->children[0])-evaluateExpression(root->children[1]));
	}
	else if(strcmp(a,"*")==0){
		return (evaluateExpression(root->children[0])*evaluateExpression(root->children[1]));
	}
	else if(strcmp(a,"/")==0){
		return ((float)evaluateExpression(root->children[0])/(float)evaluateExpression(root->children[1]));
	}
	else if(strcmp(a,"%")==0){
		return ((int)evaluateExpression(root->children[0])%(int)evaluateExpression(root->children[1]));
	}
	else if(p==1){
		if(a[0]=='i'){
		for(int i=0;i<strlen(a);)
		    {
			if(a[i]=='{')
			{
			    i++;
			    char* word;
			    int start =i;
			    
			    while(a[i]!='}')
			    {
				i++;
			    }
			    word = (char *)malloc(i - start+1);
			    word[i - start] = '\0'; 
			    strncpy(word, a + start, i - start);
			    return lookup_value(word);
			}			
			else{
			    i++;
			}
		   }		
	}
	else if(a[0]=='c'){
		for(int i=0;i<strlen(a);)
		    {
			if(a[i]=='{')
			{
			    i++;
			    char* word;
			    int start =i;
			    
			    while(a[i]!='}')
			    {
				i++;
			    }
			    word = (char *)malloc(i - start+1);
			    word[i - start] = '\0'; 
			    strncpy(word, a + start, i - start);
			    return atof(word);
			}			
			else{
			    i++;
			}
		   }
	}
	}
	else if(p==2)
		{
			int y=0;
			int flag=0;
				for(int i=0,k=0;i<strlen(a);)
				    {
				    	
				    	char*name;
				    	if(a[i]=='{')
					{
					    k++;
					    if(k==1)
					    {
						    if(a[i+1]=='i')
						    {flag=1;}
					    }
					   
					}				    	
				        if(k<1)
				        {
				        	y++;
				        }
					
					if(k==2)
					{
					
					    i++;
					    k++;
					    char* word;
					    int start =i;
					    
					    while(a[i]!='}')
					    {
						i++;
					    }
					    word = (char *)malloc(i - start+1);
					    word[i - start] = '\0'; 
					    strncpy(word, a + start, i - start);
					    //word done
					    if(flag==1){
					    
						    int index =(int)lookup_value(word);
						    name = (char *)malloc(y +1);
					            name[y] = '\0';
						    printf("y: %d\n",y);
						     
						    strncpy(name, a , y);
						    char * x;
						    sprintf(x,"[%d]",index);
						    strcat(name,x);
						    return lookup_value(name);
						    
					    }
					    else
					    {
					    	name = (char *)malloc(y +1);
					            name[y] = '\0';
						    
						     
						    strncpy(name, a , y);
					        
					    	char x[100];
					    	sprintf(x,"[%s]",word);
					    	
					    	
					    	strcat(name,x);
					    	
					    	return lookup_value(name);
					    }
					    
					    
					}
					else{								
					    i++;
					    }
				   }
			}
	
	else{
	return 0.0;
	}
}
bool REL_condition(TreeNode * root)
{
	char* a = root->value;
	if(strcmp(a,"=")==0){
		return (evaluateExpression(root->children[0])==evaluateExpression(root->children[1]));
	}
	else if(strcmp(a,"<>")==0){
		return (evaluateExpression(root->children[0])!=evaluateExpression(root->children[1]));
	}
	else if(strcmp(a,">")==0){
		return (evaluateExpression(root->children[0])>evaluateExpression(root->children[1]));
	}
	else if(strcmp(a,"<")==0){
		return (evaluateExpression(root->children[0])<evaluateExpression(root->children[1]));
	}
	else if(strcmp(a,">=")==0){
		return (evaluateExpression(root->children[0])>=evaluateExpression(root->children[1]));
	}
	else if(strcmp(a,"<=")==0){
		return (evaluateExpression(root->children[0])<=evaluateExpression(root->children[1]));
	}
}
bool bo_condition()
{

}

int for1cond(TreeNode * root)//condi
{
	int start = (int)evaluateExpression(root->children[0]->children[1]);
	int final = (int)evaluateExpression(root->children[2]->children[1]);
	return (final-start+1);
	
	
}
int for2cond(TreeNode * root)//condi
{
	int start = (int)evaluateExpression(root->children[0]->children[1]);
	int final = (int)evaluateExpression(root->children[2]->children[1]);
	return (start-final+1);
	
	
}

void treeTraversal(TreeNode * root){
	
	if(root==NULL)
	{
	
	return;
	}
	if(strcasecmp(root->value,":=")==0)
	{assignment(root);}
	else if(strcasecmp(root->value,"WRITE")==0)
	{
		if(root->children[0]->value[0]=='{')
		{
			for(int i=2;i<strlen(root->children[0]->value)-2;i++)
			printf("%c",root->children[0]->value[i]);
			printf("\n");
		}
		else
		{
			int j=0;
			while(root->children[j]!=NULL)
			{
				j++;
			}
			for(int i=0;i<j;i++)
			{
				char * a = root->children[i]->value;
				for(int i=0;i<strlen(a);)
				    {
					if(a[i]=='{')
					{
					    i++;
					    char* word;
					    int start =i;
					    
					    while(a[i]!='}')
					    {
						i++;
					    }
					    word = (char *)malloc(i - start+1);
					    word[i - start] = '\0'; 
					    strncpy(word, a + start, i - start);
					    float value= lookup_value(word);
					   if(strcasecmp(lookup_type(word),"Integer")==0)
					   {printf("%d\n",(int)value);}
					   else
					   {printf("%f\n",value);}
					}			
					else{
					    i++;
					}
				   }
			}	
		}
	}
	else if(strcasecmp(root->value,"READ")==0){		
		char * a = root->children[0]->value;
		int p=0;
		for(int j=0;j<strlen(a);j++)
		{
			if(a[j]=='{')
			{
				p++;
			}			
		}
		if(p==1){
				for(int i=0;i<strlen(a);)
				    {
					if(a[i]=='{')
					{
					    i++;
					    char* word;
					    int start =i;
					    
					    while(a[i]!='}')
					    {
						i++;
					    }
					    word = (char *)malloc(i - start+1);
					    word[i - start] = '\0'; 
					    strncpy(word, a + start, i - start);
					    
					    //word done
					    float f;
					    scanf("%f",&f);
					    				
					    setValue(word,f);
					    
					}			
					else{
					    i++;
					}
				   }
			}
		else if(p==2)
		{
			int y=0;
			int flag=0;
				for(int i=0,k=0;i<strlen(a);)
				    {
				    	
				    	char*name;
				    	if(a[i]=='{')
					{
					    k++;
					    if(k==1)
					    {
						    if(a[i+1]=='i')
						    {flag=1;}
					    }
					   
					}				    	
				        if(k<1)
				        {
				        	y++;
				        }
					
					if(k==2)
					{
					
					    i++;
					    k++;
					    char* word;
					    int start =i;
					    
					    while(a[i]!='}')
					    {
						i++;
					    }
					    word = (char *)malloc(i - start+1);
					    word[i - start] = '\0'; 
					    strncpy(word, a + start, i - start);
					    //word done
					    if(flag==1){
					    
						    int index =(int)lookup_value(word);
						    name = (char *)malloc(y +1);
					            name[y] = '\0';
						    printf("y: %d\n",y);
						     
						    strncpy(name, a , y);
						    char * x;
						    sprintf(x,"[%d]",index);
						    strcat(name,x);
						    float f;
					    	    scanf("%f",&f);				
					            setValue(name,f);
					    }
					    else
					    {
					    	name = (char *)malloc(y +1);
					            name[y] = '\0';
						    
						     
						    strncpy(name, a , y);
					        
					    	char x[100];
					    	sprintf(x,"[%s]",word);
					    	
					    	
					    	strcat(name,x);
					    	
					    	float f;
					        scanf("%f",&f);				
					        setValue(name,f);
					    }
					    
					    
					}
					else{								
					    i++;
					    }
				   }
			}
	}
	else if(strcasecmp(root->value,"IF2")==0){
		if(REL_condition(root->children[0]->children[0]))
		{
			treeTraversal(root->children[1]);
		}
		else
		{
			return;
		}
	}
	else if(strcasecmp(root->value,"IF1")==0){
		if(REL_condition(root->children[0]->children[0]))
		{
			printf("inside %s",root->children[0]->value);
			treeTraversal(root->children[1]);
		}
		else
		{
			treeTraversal(root->children[2]);
		}	
	}
	else if(strcasecmp(root->value,"WHILE")==0){
		
		while(REL_condition(root->children[0]->children[0]))
		{
			treeTraversal(root->children[1]);
		}
		return;
	}
	else if(strcasecmp(root->value,"FOR1")==0){
		
		int x =for1cond(root->children[0]);
		for(int i=0;i<x;i++)
		{
		treeTraversal(root->children[1]);
		}
		return;
	}
	else if(strcasecmp(root->value,"FOR2")==0){
		
		int x =for2cond(root->children[0]);
		for(int i=0;i<x;i++)
		{treeTraversal(root->children[1]);}
		return;
	}
	
	
	else{
		int j=0;
		while(root->children[j]!=NULL)
		{
			j++;
		}
		for(int i=0;i<j;i++)
		{
			treeTraversal(root->children[i]);
		}		
	}
	
}
