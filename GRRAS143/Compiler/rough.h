#ifndef ROUGH_H
#define ROUGH_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define MAX_LEN 10000
// Define the structure of a TreeNode
typedef struct TreeNode {
    char* value;
    struct TreeNode* children[25];
} TreeNode;

//stack implementation
struct StackNode {
    TreeNode* data;
    struct StackNode* next;
};
// Symbol table entry structure
typedef struct {
    char name[MAX_LEN];
    char type[MAX_LEN];
    int initialized;
    union {
        int ival;
        float fval;
    } value; // Added name for the union
} SymbolEntry;




struct StackNode* newStack(TreeNode* data);
int isEmpty(struct StackNode* root);
void push(struct StackNode** root, TreeNode* data);
TreeNode* pop(struct StackNode** root);
TreeNode * peek(struct StackNode* root);
TreeNode* createNode(char* value);
void addChild(TreeNode* parent, TreeNode* child);
void printTree(TreeNode* root);
TreeNode* createTree(char* str);
//symbol table sign
void printSymbolTable();
int isDeclared(char* name);
void addToSymbolTable(char* name, char* type);
void printUndeclaredError(char* name);
void printMultipleDeclarationsError(char* name);
char* lookup_type(char* name);
void set_initialized(char* name);
void declareVariable(char* name, char* type);
int checkVariableUsage(char* name);
int check_AssignVariableUsage(char* name);
int checkTypeCompatibility(char* type1, char* type2, char* type3);
void printTypeMismatchError(char* expectedType, char* actualType);
void checkAssignmentType(char* expr1Type, char* expr2Type, char* expr3Type);
void printArrayIndexTypeMismatchError(char* expectedType, char* actualType);
void setType(char* type);
void TreeTraversal(TreeNode * root);
float evaluateExpression(TreeNode * root);
void setarraytype(char* type);
#endif

