#ifndef YY_parse_h_included
#define YY_parse_h_included
/*#define YY_USE_CLASS 
*/
#line 1 "/usr/share/bison++/bison.h"
/* before anything */
#ifdef c_plusplus
 #ifndef __cplusplus
  #define __cplusplus
 #endif
#endif


 #line 8 "/usr/share/bison++/bison.h"

#line 174 "semantic.y"
typedef union{
struct{
char* type;
union{
int ival;
float fval;
//char cval;
char* sval;
}v; }t;
} yy_parse_stype;
#define YY_parse_STYPE yy_parse_stype
#ifndef YY_USE_CLASS
#define YYSTYPE yy_parse_stype
#endif

#line 21 "/usr/share/bison++/bison.h"
 /* %{ and %header{ and %union, during decl */
#ifndef YY_parse_COMPATIBILITY
 #ifndef YY_USE_CLASS
  #define  YY_parse_COMPATIBILITY 1
 #else
  #define  YY_parse_COMPATIBILITY 0
 #endif
#endif

#if YY_parse_COMPATIBILITY != 0
/* backward compatibility */
 #ifdef YYLTYPE
  #ifndef YY_parse_LTYPE
   #define YY_parse_LTYPE YYLTYPE
/* WARNING obsolete !!! user defined YYLTYPE not reported into generated header */
/* use %define LTYPE */
  #endif
 #endif
/*#ifdef YYSTYPE*/
  #ifndef YY_parse_STYPE
   #define YY_parse_STYPE YYSTYPE
  /* WARNING obsolete !!! user defined YYSTYPE not reported into generated header */
   /* use %define STYPE */
  #endif
/*#endif*/
 #ifdef YYDEBUG
  #ifndef YY_parse_DEBUG
   #define  YY_parse_DEBUG YYDEBUG
   /* WARNING obsolete !!! user defined YYDEBUG not reported into generated header */
   /* use %define DEBUG */
  #endif
 #endif 
 /* use goto to be compatible */
 #ifndef YY_parse_USE_GOTO
  #define YY_parse_USE_GOTO 1
 #endif
#endif

/* use no goto to be clean in C++ */
#ifndef YY_parse_USE_GOTO
 #define YY_parse_USE_GOTO 0
#endif

#ifndef YY_parse_PURE

 #line 65 "/usr/share/bison++/bison.h"

#line 65 "/usr/share/bison++/bison.h"
/* YY_parse_PURE */
#endif


 #line 68 "/usr/share/bison++/bison.h"

#line 68 "/usr/share/bison++/bison.h"
/* prefix */

#ifndef YY_parse_DEBUG

 #line 71 "/usr/share/bison++/bison.h"

#line 71 "/usr/share/bison++/bison.h"
/* YY_parse_DEBUG */
#endif

#ifndef YY_parse_LSP_NEEDED

 #line 75 "/usr/share/bison++/bison.h"

#line 75 "/usr/share/bison++/bison.h"
 /* YY_parse_LSP_NEEDED*/
#endif

/* DEFAULT LTYPE*/
#ifdef YY_parse_LSP_NEEDED
 #ifndef YY_parse_LTYPE
  #ifndef BISON_YYLTYPE_ISDECLARED
   #define BISON_YYLTYPE_ISDECLARED
typedef
  struct yyltype
    {
      int timestamp;
      int first_line;
      int first_column;
      int last_line;
      int last_column;
      char *text;
   }
  yyltype;
  #endif

  #define YY_parse_LTYPE yyltype
 #endif
#endif

/* DEFAULT STYPE*/
#ifndef YY_parse_STYPE
 #define YY_parse_STYPE int
#endif

/* DEFAULT MISCELANEOUS */
#ifndef YY_parse_PARSE
 #define YY_parse_PARSE yyparse
#endif

#ifndef YY_parse_LEX
 #define YY_parse_LEX yylex
#endif

#ifndef YY_parse_LVAL
 #define YY_parse_LVAL yylval
#endif

#ifndef YY_parse_LLOC
 #define YY_parse_LLOC yylloc
#endif

#ifndef YY_parse_CHAR
 #define YY_parse_CHAR yychar
#endif

#ifndef YY_parse_NERRS
 #define YY_parse_NERRS yynerrs
#endif

#ifndef YY_parse_DEBUG_FLAG
 #define YY_parse_DEBUG_FLAG yydebug
#endif

#ifndef YY_parse_ERROR
 #define YY_parse_ERROR yyerror
#endif

#ifndef YY_parse_PARSE_PARAM
 #ifndef __STDC__
  #ifndef __cplusplus
   #ifndef YY_USE_CLASS
    #define YY_parse_PARSE_PARAM
    #ifndef YY_parse_PARSE_PARAM_DEF
     #define YY_parse_PARSE_PARAM_DEF
    #endif
   #endif
  #endif
 #endif
 #ifndef YY_parse_PARSE_PARAM
  #define YY_parse_PARSE_PARAM void
 #endif
#endif

/* TOKEN C */
#ifndef YY_USE_CLASS

 #ifndef YY_parse_PURE
  #ifndef yylval
   extern YY_parse_STYPE YY_parse_LVAL;
  #else
   #if yylval != YY_parse_LVAL
    extern YY_parse_STYPE YY_parse_LVAL;
   #else
    #warning "Namespace conflict, disabling some functionality (bison++ only)"
   #endif
  #endif
 #endif


 #line 169 "/usr/share/bison++/bison.h"
#define	T_LT	258
#define	T_GT	259
#define	T_LE	260
#define	T_GE	261
#define	T_EQUAL	262
#define	T_UNEQUAL	263
#define	T_PLUS	264
#define	T_MINUS	265
#define	T_OR	266
#define	T_MUL	267
#define	T_DIV	268
#define	T_MOD	269
#define	T_AND	270
#define	T_NOT	271
#define	T_PROGRAM	272
#define	T_VAR	273
#define	T_INT	274
#define	T_REAL	275
#define	T_ID	276
#define	T_STRING	277
#define	T_BEGIN	278
#define	T_END	279
#define	T_READ	280
#define	T_WRITE	281
#define	T_IF	282
#define	T_THEN	283
#define	T_ELSE	284
#define	T_WHILE	285
#define	T_DO	286
#define	T_TO	287
#define	T_DOWNTO	288
#define	T_FOR	289
#define	T_ASSIGN	290
#define	T_LB	291
#define	T_RB	292
#define	T_LP	293
#define	T_RP	294
#define	T_SEMI	295
#define	T_DOT	296
#define	T_DOTDOT	297
#define	T_COMMA	298
#define	T_COLON	299
#define	T_INTEGER_TYPE	300
#define	T_BOOLEAN_TYPE	301
#define	T_CHAR_TYPE	302
#define	T_REAL_TYPE	303
#define	T_ARRAY	304
#define	T_OF	305


#line 169 "/usr/share/bison++/bison.h"
 /* #defines token */
/* after #define tokens, before const tokens S5*/
#else
 #ifndef YY_parse_CLASS
  #define YY_parse_CLASS parse
 #endif

 #ifndef YY_parse_INHERIT
  #define YY_parse_INHERIT
 #endif

 #ifndef YY_parse_MEMBERS
  #define YY_parse_MEMBERS 
 #endif

 #ifndef YY_parse_LEX_BODY
  #define YY_parse_LEX_BODY  
 #endif

 #ifndef YY_parse_ERROR_BODY
  #define YY_parse_ERROR_BODY  
 #endif

 #ifndef YY_parse_CONSTRUCTOR_PARAM
  #define YY_parse_CONSTRUCTOR_PARAM
 #endif
 /* choose between enum and const */
 #ifndef YY_parse_USE_CONST_TOKEN
  #define YY_parse_USE_CONST_TOKEN 0
  /* yes enum is more compatible with flex,  */
  /* so by default we use it */ 
 #endif
 #if YY_parse_USE_CONST_TOKEN != 0
  #ifndef YY_parse_ENUM_TOKEN
   #define YY_parse_ENUM_TOKEN yy_parse_enum_token
  #endif
 #endif

class YY_parse_CLASS YY_parse_INHERIT
{
public: 
 #if YY_parse_USE_CONST_TOKEN != 0
  /* static const int token ... */
  
 #line 212 "/usr/share/bison++/bison.h"
static const int T_LT;
static const int T_GT;
static const int T_LE;
static const int T_GE;
static const int T_EQUAL;
static const int T_UNEQUAL;
static const int T_PLUS;
static const int T_MINUS;
static const int T_OR;
static const int T_MUL;
static const int T_DIV;
static const int T_MOD;
static const int T_AND;
static const int T_NOT;
static const int T_PROGRAM;
static const int T_VAR;
static const int T_INT;
static const int T_REAL;
static const int T_ID;
static const int T_STRING;
static const int T_BEGIN;
static const int T_END;
static const int T_READ;
static const int T_WRITE;
static const int T_IF;
static const int T_THEN;
static const int T_ELSE;
static const int T_WHILE;
static const int T_DO;
static const int T_TO;
static const int T_DOWNTO;
static const int T_FOR;
static const int T_ASSIGN;
static const int T_LB;
static const int T_RB;
static const int T_LP;
static const int T_RP;
static const int T_SEMI;
static const int T_DOT;
static const int T_DOTDOT;
static const int T_COMMA;
static const int T_COLON;
static const int T_INTEGER_TYPE;
static const int T_BOOLEAN_TYPE;
static const int T_CHAR_TYPE;
static const int T_REAL_TYPE;
static const int T_ARRAY;
static const int T_OF;


#line 212 "/usr/share/bison++/bison.h"
 /* decl const */
 #else
  enum YY_parse_ENUM_TOKEN { YY_parse_NULL_TOKEN=0
  
 #line 215 "/usr/share/bison++/bison.h"
	,T_LT=258
	,T_GT=259
	,T_LE=260
	,T_GE=261
	,T_EQUAL=262
	,T_UNEQUAL=263
	,T_PLUS=264
	,T_MINUS=265
	,T_OR=266
	,T_MUL=267
	,T_DIV=268
	,T_MOD=269
	,T_AND=270
	,T_NOT=271
	,T_PROGRAM=272
	,T_VAR=273
	,T_INT=274
	,T_REAL=275
	,T_ID=276
	,T_STRING=277
	,T_BEGIN=278
	,T_END=279
	,T_READ=280
	,T_WRITE=281
	,T_IF=282
	,T_THEN=283
	,T_ELSE=284
	,T_WHILE=285
	,T_DO=286
	,T_TO=287
	,T_DOWNTO=288
	,T_FOR=289
	,T_ASSIGN=290
	,T_LB=291
	,T_RB=292
	,T_LP=293
	,T_RP=294
	,T_SEMI=295
	,T_DOT=296
	,T_DOTDOT=297
	,T_COMMA=298
	,T_COLON=299
	,T_INTEGER_TYPE=300
	,T_BOOLEAN_TYPE=301
	,T_CHAR_TYPE=302
	,T_REAL_TYPE=303
	,T_ARRAY=304
	,T_OF=305


#line 215 "/usr/share/bison++/bison.h"
 /* enum token */
     }; /* end of enum declaration */
 #endif
public:
 int YY_parse_PARSE(YY_parse_PARSE_PARAM);
 virtual void YY_parse_ERROR(char *msg) YY_parse_ERROR_BODY;
 #ifdef YY_parse_PURE
  #ifdef YY_parse_LSP_NEEDED
   virtual int  YY_parse_LEX(YY_parse_STYPE *YY_parse_LVAL,YY_parse_LTYPE *YY_parse_LLOC) YY_parse_LEX_BODY;
  #else
   virtual int  YY_parse_LEX(YY_parse_STYPE *YY_parse_LVAL) YY_parse_LEX_BODY;
  #endif
 #else
  virtual int YY_parse_LEX() YY_parse_LEX_BODY;
  YY_parse_STYPE YY_parse_LVAL;
  #ifdef YY_parse_LSP_NEEDED
   YY_parse_LTYPE YY_parse_LLOC;
  #endif
  int YY_parse_NERRS;
  int YY_parse_CHAR;
 #endif
 #if YY_parse_DEBUG != 0
  public:
   int YY_parse_DEBUG_FLAG;	/*  nonzero means print parse trace	*/
 #endif
public:
 YY_parse_CLASS(YY_parse_CONSTRUCTOR_PARAM);
public:
 YY_parse_MEMBERS 
};
/* other declare folow */
#endif


#if YY_parse_COMPATIBILITY != 0
 /* backward compatibility */
 /* Removed due to bison problems
 /#ifndef YYSTYPE
 / #define YYSTYPE YY_parse_STYPE
 /#endif*/

 #ifndef YYLTYPE
  #define YYLTYPE YY_parse_LTYPE
 #endif
 #ifndef YYDEBUG
  #ifdef YY_parse_DEBUG 
   #define YYDEBUG YY_parse_DEBUG
  #endif
 #endif

#endif
/* END */

 #line 267 "/usr/share/bison++/bison.h"
#endif
