Group Code:
GRRAS143

Group Members:
1. Name: Atharva Shrivastava
2. Name: Raj Jain
3. Name: Rishi Goyal
4. Name: Saransh Kasliwal
5. Name: Giriraj Chandak

Instructions for Compiling Programs:
Task 3: Part1 Semantic Analysis

Compilation Command:
1. yacc -d semantic.y
2. lex semantic.l
3. gcc lex.yy.c y.tab.c -ll
4. ./a.out

Task 3: Part2 Abstract Syntax Tree

Compilation Command:
1. yacc -d ast.y
2. lex ast.l
3. gcc lex.yy.c y.tab.c -ll
4. ./a.out> p1.txt
5.python3 tree.py

Task 4: 3 Address Code

Compilation Command:
1. yacc -d 3ac.y
2. lex 3ac.l
3. gcc lex.yy.c y.tab.c -ll
4. ./a.out

Task 5: Compiler Outputs

Compilation Command:
1. yacc -d p1.y
2. lex p1.l
3. gcc lex.yy.c y.tab.c rough.c -ll
4. ./a.out



