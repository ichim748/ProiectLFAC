%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <stdbool.h>
extern FILE* yyin;
extern char* yytext;
extern int yylineno;

union value{
     int intVal;
     bool boolVal;
     float floatVal;
     char strVal[101];
     char charVal;
};
typedef struct Expr {
    char type[200];
    int intVal;
    bool boolVal;
    char charVal;
    float floatVal;
    char* strVal;
}Expr;

struct variable{
     bool isConst;
     bool isInit;
     char scope[200];
     char name[200];
     char type[200];
     int arraySize;
     int intVal;
     int * intArrayVal;
     bool boolVal;
     bool * boolArrayVal;
     float floatVal;
     float * floatArrayVal;
     char strVal[101];
     char charVal; 
}vars[100];

typedef struct var{
     bool isConst;
     char name[200];
     char type[200];
     char scope[200];
     int arraySize;
     int intVal;
     int * intArrayVal;
     bool boolVal;
     bool * boolArrayVal;
     float floatVal;
     float * floatArrayVal;
     char strVal[101];
     char charVal;
}variabila;
typedef struct substructura{
     char name[200];
     int memberCount;
     variabila membri[200];
}substruct;
struct structDescr{
     char name[200];
     char scope[200];
     int memberCount;
     int substructCount;
     int substructuri[200];
     variabila membri[200];
}structs[100];
char params[101];
struct function{
     char name[200];
     char type[200];
     char params[100];
     char functionBody[300];
     bool isInit;
}functions[100];
int structCounter = 0;
int valCounter = 0;
int funcCounter = 0;

void printStructures(FILE * fd){
     int i, j;
     fprintf(fd, "Tipurile definite de catre utilizator:\n");
     for (i=0;i<structCounter;i++){
          fprintf(fd, "    Structura %s are scope-ul %s si are urmatorii membri:\n", structs[i].name, structs[i].scope);
          for(j=0;j<structs[i].memberCount;j++){
               fprintf(fd, "        Variabila %s, de tipul %s, cu scope-ul %s.\n", structs[i].membri[j].name, structs[i].membri[j].type, structs[i].membri[j].scope);
          }
          for(j=0;j<structs[i].substructCount;j++){
               fprintf(fd, "        Substructura %s, de tipul struct cu scope-ul struct_member.\n", structs[structs[i].substructuri[j]].name);
          }
     }
}
void printVars(FILE * fd){
     fprintf(fd, "Variabilele si constantele:\n");
     for (int i = 0;i < valCounter;i++){
          if (vars[i].isInit){ //Daca conteaza valoarea sa
               if (strcmp(vars[i].type, "int") == 0) {fprintf(fd, "    Variabila %s are tipul %s, valoare lui isConst este %d si are valoarea %d.\n", vars[i].name, vars[i].type, vars[i].isConst, vars[i].intVal);}
               else if (strcmp(vars[i].type, "bool") == 0) {fprintf(fd, "    Variabila %s are tipul %s, valoare lui isConst este %d si are valoarea %d.\n", vars[i].name, vars[i].type, vars[i].isConst, vars[i].boolVal);}
               else if (strcmp(vars[i].type, "float") == 0) {fprintf(fd, "    Variabila %s are tipul %s, valoare lui isConst este %d si are valoarea %f.\n", vars[i].name, vars[i].type, vars[i].isConst, vars[i].floatVal);}
               else if (strcmp(vars[i].type, "char") == 0) {fprintf(fd, "    Variabila %s are tipul %s, valoare lui isConst este %d si are valoarea %c.\n", vars[i].name, vars[i].type, vars[i].isConst, vars[i].charVal);}
               else if (strcmp(vars[i].type, "string") == 0) {fprintf(fd, "    Variabila %s are tipul %s, valoare lui isConst este %d si are valoarea %s.\n", vars[i].name, vars[i].type, vars[i].isConst, vars[i].strVal);}
               else if (strcmp(vars[i].type, "intArray") == 0) {
                    fprintf(fd, "    Variabila %s are tipul %s, valoare lui isConst este %d si are valoarile (dimensiunea este de %d) :\n", vars[i].name, vars[i].type, vars[i].isConst, vars[i].arraySize);
                    fprintf(fd, "        ");
                    for (int j=0; j<vars[i].arraySize;j++){
                         fprintf(fd, "%d ", vars[i].intArrayVal[j]);
                    }
                    fprintf(fd, "\n");
               }
               else if (strcmp(vars[i].type, "boolArray") == 0) {
                    fprintf(fd, "    Variabila %s are tipul %s, valoare lui isConst este %d si are valoarile :\n", vars[i].name, vars[i].type, vars[i].isConst);
                    fprintf(fd, "        ");
                    for (int j=0; j<vars[i].arraySize;j++){
                         fprintf(fd, "%d ", vars[i].boolArrayVal[j]);
                    }
                    fprintf(fd, "\n");
               }
               else if (strcmp(vars[i].type, "floatArray") == 0) {
                    fprintf(fd, "    Variabila %s are tipul %s, valoare lui isConst este %d si are valoarile :\n", vars[i].name, vars[i].type, vars[i].isConst);
                    fprintf(fd, "        ");
                    for (int j=0; j<vars[i].arraySize;j++){
                         fprintf(fd, "%f ", vars[i].floatArrayVal[j]);
                    }
                    fprintf(fd, "\n");
               }    
          }
          else{
               fprintf(fd, "    Variabila %s are tipul %s si isInit pentru variabila aceasta este : %d.\n", vars[i].name, vars[i].type, vars[i].isInit);
          }
     }
}
void printFunctions(FILE * file){
     int i;
     for(i=0;i<funcCounter;i++) fprintf(file, "Numele functiei este %s, tipul ei de return este %s si parametrii sunt: \n    %s \n", functions[i].name, functions[i].type, functions[i].params);  
}
int existsVar(char * varName){
     int i=0;
     for(i=0;i < valCounter;i++){
          if(strcmp(vars[i].name, varName) == 0){
               return i;
          }
     }
     return -1;
}
int existsStruct(char * varName){
     int i=0;
     for(i=0;i < structCounter;i++){
          if(strcmp(structs[i].name, varName) == 0){
               return i;
          }
     }
     return -1;
}
int declareStructValue(char * name, char * type, bool isConst, int constInt, char * constString, char constChar, float constFloat){
     int i;
     for(i=0;i < valCounter;i++){
          if(strcmp(vars[i].name, name) == 0){
               return 2;
          }
     }
     for(i=0;i < structCounter;i++){
          if(strcmp(structs[i].name, name) == 0){
               return 2;
          }
     }
     strcpy(structs[structCounter-1].membri[structs[structCounter-1].memberCount].name, name);
     strcpy(structs[structCounter-1].membri[structs[structCounter-1].memberCount].scope, "struct_member");
     strcpy(structs[structCounter-1].membri[structs[structCounter-1].memberCount].type, type);
     structs[structCounter-1].membri[structs[structCounter-1].memberCount].isConst = 0;
     structs[structCounter-1].memberCount = structs[structCounter-1].memberCount + 1;
     return 0;
}
int declareStructArray(char * name, char * type, int dimension){
     int i;
     for(i=0;i < valCounter;i++){
          if(strcmp(vars[i].name, name) == 0){
               return 2;
          }
     }
     for(i=0;i < structCounter;i++){
          if(strcmp(structs[i].name, name) == 0){
               return 2;
          }
     }
     strcpy(structs[structCounter-1].membri[structs[structCounter-1].memberCount].name, name);
     strcpy(structs[structCounter-1].membri[structs[structCounter-1].memberCount].type, type);
     if (strcmp(structs[structCounter-1].membri[structs[structCounter-1].memberCount].type, "int") == 0){
          structs[structCounter-1].membri[structs[structCounter-1].memberCount].intArrayVal = (int *) malloc((dimension+5) * sizeof(int));
     }
     else if (strcmp(structs[structCounter-1].membri[structs[structCounter-1].memberCount].type, "float") == 0){
          structs[structCounter-1].membri[structs[structCounter-1].memberCount].floatArrayVal =(float *) malloc((dimension+5) * sizeof(float));
     }
     else if (strcmp(structs[structCounter-1].membri[structs[structCounter-1].memberCount].type, "bool") == 0){
          structs[structCounter-1].membri[structs[structCounter-1].memberCount].boolArrayVal = (bool *) malloc((dimension+5) * sizeof(bool));
     }
     structs[structCounter-1].memberCount = structs[structCounter-1].memberCount + 1;
     return 0;
}
int declareValue(char * name, char * type, bool isConst, int constInt, char * constString, char constChar, float constFloat, char * scope, bool isInit){
     int i=0;
     for(i=0;i < valCounter;i++){
          if(strcmp(vars[i].name, name) == 0){
               return 2;
          }
     }
     strcpy(vars[valCounter].name, name);
     strcpy(vars[valCounter].type, type);
     strcpy(vars[valCounter].scope, scope);
     vars[valCounter].isConst = 0;
     vars[valCounter].isInit = 0;
     if (isConst && strcmp(vars[valCounter].type, "int") == 0){
          vars[valCounter].isConst = 1;
          vars[valCounter].intVal = constInt;
          vars[valCounter].isInit = 1;
     }
     if (isConst && strcmp(vars[valCounter].type, "string") == 0){
          vars[valCounter].isConst = 1;
          strcpy(vars[valCounter].strVal, constString);
          vars[valCounter].isInit = 1;
     }
     if (isConst && strcmp(vars[valCounter].type, "char") == 0){
          vars[valCounter].isConst = 1;
          vars[valCounter].charVal = constChar;
          vars[valCounter].isInit = 1;
     }
     if (isConst && strcmp(vars[valCounter].type, "float") == 0){
          vars[valCounter].isConst = 1;
          vars[valCounter].floatVal = constFloat;
          vars[valCounter].isInit = 1;
     }
     valCounter++;
     return 0;
} //Aceasta functie marcheaza daca o variabila a fost declarata, nu si daca i s-a dat valoare
int declareArray(char * name, char * type, int dimension, char * scope){
     int i=0;
     for(i=0;i < valCounter;i++){
          if(strcmp(vars[i].name, name) == 0){
               return 2;
          }
     }
     strcpy(vars[valCounter].name, name);
     strcpy(vars[valCounter].type, type);
     strcpy(vars[valCounter].scope, scope);
     vars[valCounter].isInit = 0;
     if (strcmp(vars[valCounter].type, "int") == 0){
          vars[i].intArrayVal = (int *) malloc((dimension+5) * sizeof(int));
     }
     else if (strcmp(vars[valCounter].type, "float") == 0){
          vars[valCounter].floatArrayVal =(float *) malloc((dimension+5) * sizeof(float));
     }
     else if (strcmp(vars[valCounter].type, "bool") == 0){
          vars[valCounter].boolArrayVal = (bool *) malloc((dimension+5) * sizeof(bool));
     }
     valCounter++;
     return 0;
}
int assingIntValuesToArray(char * name, char * type, char * elements, int dimension, bool isConst, char * scope){
     int i=0;
     for(i=0;i < valCounter;i++){
          if(strcmp(vars[i].name, name) == 0){
               return 2;
          }
     }
     vars[valCounter].isInit = 1;
     strcpy(vars[valCounter].name, name);
     strcpy(vars[valCounter].type, type);
     strcpy(vars[valCounter].scope, scope);
     vars[valCounter].arraySize = dimension;
     i--;
     vars[valCounter].isConst = isConst;
     vars[valCounter].isInit = 1;
     if(strcmp(vars[valCounter].type, "intArray") == 0){
          vars[valCounter].intArrayVal = (int *) malloc((dimension+5) * sizeof(int)); 
          int j=0;
          char currentNumber[1000];
          char elemente[1000];
          strcpy(elemente, elements);
          strcpy(currentNumber, strtok (elemente,","));
          vars[valCounter].intArrayVal[j++] = atoi(currentNumber);
          while (currentNumber != NULL && j< dimension){
               strcpy(currentNumber, strtok (NULL,","));
               vars[valCounter].intArrayVal[j++] = atoi(currentNumber);
          }
          valCounter++;
     }
     else if(strcmp(vars[valCounter].type, "floatArray") == 0){
          vars[valCounter].floatArrayVal = (float *) malloc((dimension+5) * sizeof(float)); 
          int j=0;
          char currentNumber[1000];
          char elemente[1000];
          strcpy(elemente, elements);
          strcpy(currentNumber, strtok (elemente,","));
          vars[valCounter].floatArrayVal[j++] = atof(currentNumber);
          while (currentNumber != NULL && j< dimension){
               strcpy(currentNumber, strtok (NULL,","));
               vars[valCounter].floatArrayVal[j++] = atoi(currentNumber);
          }
          valCounter++;
     }
     else if(strcmp(vars[valCounter].type, "boolArray") == 0){
          vars[valCounter].boolArrayVal = (bool *) malloc((dimension+5) * sizeof(bool)); 
          int j=0;
          char currentNumber[1000];
          char elemente[1000];
          strcpy(elemente, elements);
          strcpy(currentNumber, strtok (elemente,","));
          if (strcmp(currentNumber, "adevarat") == 0){
               vars[valCounter].boolArrayVal[j++] = true;
          }
          else vars[valCounter].boolArrayVal[j++] = false;
          while (currentNumber != NULL && j< dimension){
               strcpy(currentNumber, strtok (NULL,","));
               if (strcmp(currentNumber, "adevarat") == 0){
                    vars[valCounter].boolArrayVal[j++] = true;
               }
               else vars[valCounter].boolArrayVal[j++] = false;
          }
          valCounter++;
     }
     return 0;
}

int insertFunction(char * type, char * name, char * params){
     int i = 0;
     for (i=0;i < funcCounter;i++){
           if(strcmp(functions[i].name, name) == 0 && strcmp(functions[i].params, params) == 0 && strcmp(functions[i].type, type) == 0){
               return 2;
          }
     }
     functions[funcCounter].isInit = 0;
     strcpy(functions[funcCounter].name, name);
     strcpy(functions[funcCounter].type, type);
     strcpy(functions[funcCounter].params, params);
     funcCounter++;
     return 0;
}
int insertFunctionWithBody(char * type, char * name, char * params, char * functionBody){
     int i = 0;
     for (i=0;i < funcCounter;i++){
           if(strcmp(functions[i].name, name) == 0 && strcmp(functions[i].params, params) == 0 && strcmp(functions[i].type, type) == 0){
               return 2;
          }
     }
     functions[funcCounter].isInit = 1;
     strcpy(functions[funcCounter].name, name);
     strcpy(functions[funcCounter].type, type);
     strcpy(functions[funcCounter].functionBody, functionBody);
     strcpy(functions[funcCounter].params, params);
     funcCounter++;
     return 0;
}
int existsFunc(char * type, char * name, char * params){
     int i=0;
     for(i=0;i < funcCounter;i++){
          if(strcmp(functions[i].name, name) == 0 && strcmp(functions[i].params, params) == 0 && strcmp(functions[i].type, type) == 0){
               return i;
          }
     }
     return -1;
}
int existsFunctieInBody(char * name, char * params){
     int i = 0;
     for(i=0;i < funcCounter;i++){
          if(strcmp(functions[i].name, name) == 0 && strcmp(functions[i].params, params) == 0){
               return i;
          }
     }
     return -1;
}
Expr* createSomeExpr(char* val);
Expr* createInvalidExpr();
Expr* createIntExpr(int val);
Expr* createBoolExpr(bool val);
Expr* createFloatExpr(float val);
Expr* createCharExpr(char val);
%}
%union {
int intval;
int boolval;
float floatval;
char charval;
char strval[200];
struct Expr * exprVal;
}

%token FUNCTION_BODY PRINT ID TIP STRUCT BGIN END ASSIGN GT GET LT LET EQ NEQ NR NOT SI SAU PLUS MINUS DIV MOD MUL FLOAT CONST CHAR CUVANT BOOL INT_LIST FLOAT_LIST BOOL_LIST MYIF MYWHILE MYFOR VOID PLUSPLUS MINUSMINUS

%type <exprVal> EXP
%type <intval>NR
%type <boolval>BOOL
%type <strval> TIP ID CUVANT INT_LIST FLOAT_LIST BOOL_LIST parametru lista_parametrii VOID FUNCTION_BODY
%type <floatval>FLOAT
%type <charval>CHAR


%left '{' '}' '[' ']' '(' ')'
%nonassoc NOT
%left PLUS MINUS
%nonassoc LT GT GET LET
%left MUL DIV MOD
%nonassoc EQ
%left SI SAU
%right ASSIGN

%start progr 
%%
progr: declaratii bloc {printf("program corect sintactic!\n");}
     ;

declaratii :  declaratie ';'
	   | declaratii declaratie ';'
	   ;
declaratie : TIP ID {if(existsVar($2) == -1){
                         char tip[200];
                         char id[200];
                         strcpy(tip, $1);
                         strcpy(id, $2);
                         declareValue(id, tip, false, 0, "", ' ', 0, "global", 0);
                    }else{
                         printf("Eroare la linia %d! Variabila %s este deja declarata.\n", yylineno, $2);
                         exit(0);
                    };}
           | CONST TIP ID {printf("Eroare la linia %d! Trebuie declarata valoarea constantei.\n", yylineno);exit(0);}
           | CONST TIP ID ASSIGN NR {if(existsVar($3) == -1){
                                   if (strcmp($2, "int") == 0){
                                        char tip[200];
                                        char id[200];
                                        strcpy(tip, $2);
                                        strcpy(id, $3);
                                        declareValue(id, tip, true, $5, "", ' ', 0, "global", 1);
                                   }
                                   else {printf("Eroare la linia %d! Tipul variabilei %s nu se potriveste.\n", yylineno, $2);exit(0);}
                                 }else{
                                   printf("Eroare la linia %d! Variabila %s este deja declarata.\n", yylineno, $2);exit(0);
                    };}
          | CONST TIP ID ASSIGN FLOAT {if(existsVar($3) == -1){
                                   if (strcmp($2, "float") == 0){
                                        char tip[200];
                                        char id[200];
                                        strcpy(tip, $2);
                                        strcpy(id, $3);
                                        declareValue(id, tip, true, 0, "", ' ', $5, "global", 1);
                                   }
                                   else {printf("Eroare la linia %d! Tipul variabilei %s nu se potriveste.\n", yylineno, $2);exit(0);}
                                 }else{
                                   printf("Eroare la linia %d! Variabila %s este deja declarata.\n", yylineno, $2);exit(0);
                    };}
           | CONST TIP ID ASSIGN CHAR {
                              if(existsVar($3) == -1){
                                   char tip[200];
                                   char id[200];
                                   if (strcmp($2, "char") == 0){
                                        strcpy(tip, $2);
                                        strcpy(id, $3);
                                        declareValue(id, tip, true, 0, "", $5, 0, "global", 1);
                                   }
                                   else {printf("Eroare la linia %d! Tipul variabilei %s nu se potriveste.\n", yylineno, $3);exit(0);}
                              }else{
                                   printf("Eroare la linia %d! Variabila %s este deja declarata.\n", yylineno, $3);exit(0);
                    };}
           | CONST TIP ID ASSIGN CUVANT {if(existsVar($3) == -1){
                                   char tip[200];
                                   char id[200];
                                   if (strcmp($2, "string") == 0){
                                        strcpy(tip, $2);
                                        strcpy(id, $3);
                                        declareValue(id, tip, true, 0, $5, ' ', 0, "global", 1);
                                   }
                                   else if (strcmp($2, "char") == 0 && strlen($5) >= 1){
                                        strcpy(tip, $2);
                                        strcpy(id, $3);
                                        declareValue(id, tip, true, 0, "", $5[1], 0, "global", 1);
                                   }
                                   else {printf("Eroare la linia %d! Tipul variabilei %s nu se potriveste.\n", yylineno, $3);exit(0);}
                                 }else{
                                   printf("Eroare la linia %d! Variabila %s este deja declarata.\n", yylineno, $3);exit(0);
                    };}
           | TIP ID '[' NR ']' {if(existsVar($2) == -1){
                                   char tip[200];
                                   char id[200];
                                   int dimension = $4;
                                   strcpy(tip, $1);
                                   strcat(tip, "Array");
                                   strcpy(id, $2);
                                   declareArray(id, tip, dimension, "global");
                              }else{
                                   printf("Eroare la linia %d! Variabila %s este deja declarata.\n", yylineno, $2);exit(0);
                    };}
           | TIP ID '['']' ASSIGN '{' INT_LIST '}' {if(existsVar($2) == -1){
                                                  char tip[200];
                                                  char id[200];
                                                  int i, contor;
                                                  contor = 0;
                                                  strcpy(tip, $1);
                                                  strcat(tip, "Array");
                                                  strcpy(id, $2);
                                                  for(i=0;i<strlen($7);i++){
                                                       if($7[i] == ','){
                                                            contor++;
                                                       }
                                                  }
                                                  contor++;
                                                  assingIntValuesToArray(id, tip, $7, contor, 0, "global");
                                              }else{
                                                  printf("Eroare la linia %d! Variabila %s este deja declarata.\n", yylineno, $2);exit(0);
                                              };}
           | TIP ID '['']' ASSIGN '{' FLOAT_LIST '}' {if(existsVar($2) == -1){
                                                  char tip[200];
                                                  char id[200];
                                                  int i, contor;
                                                  contor = 0;
                                                  strcpy(tip, $1);
                                                  strcat(tip, "Array");
                                                  strcpy(id, $2);
                                                  for(i=0;i<strlen($7);i++){
                                                       if($7[i] == ','){
                                                            contor++;
                                                       }
                                                  }
                                                  contor++;
                                                  assingIntValuesToArray(id, tip, $7, contor, 0, "global");
                                              }else{
                                                  printf("Eroare la linia %d! Variabila %s este deja declarata.\n", yylineno, $2);exit(0);
                                              };}
           | TIP ID '['']' ASSIGN '{' BOOL_LIST '}' {if(existsVar($2) == -1){
                                                  char tip[200];
                                                  char id[200];
                                                  int i, contor;
                                                  contor = 0;
                                                  strcpy(tip, $1);
                                                  strcat(tip, "Array");
                                                  strcpy(id, $2);
                                                  for(i=0;i<strlen($7);i++){
                                                       if($7[i] == ','){
                                                            contor++;
                                                       }
                                                  }
                                                  contor++;
                                                  assingIntValuesToArray(id, tip, $7, contor, 0, "global");
                                              }else{
                                                  printf("Eroare la linia %d! Variabila %s este deja declarata.\n", yylineno, $2);exit(0);
                                              };}
           | CONST TIP ID '['']' ASSIGN '{' INT_LIST '}' {if(existsVar($3) == -1){
                                                  char tip[200];
                                                  char id[200];
                                                  int i, contor;
                                                  contor = 0;
                                                  strcpy(tip, $2);
                                                  strcat(tip, "Array");
                                                  strcpy(id, $3);
                                                  for(i=0;i<strlen($8);i++){
                                                       if($8[i] == ','){
                                                            contor++;
                                                       }
                                                  }
                                                  contor++;
                                                  assingIntValuesToArray(id, tip, $8, contor, 1, "global");
                                              }else{
                                                  printf("Eroare la linia %d! Variabila %s este deja declarata.\n", yylineno, $3);exit(0);
                                              };}
           | CONST TIP ID '['']' ASSIGN '{' FLOAT_LIST '}' {if(existsVar($3) == -1){
                                                  char tip[200];
                                                  char id[200];
                                                  int i, contor;
                                                  contor = 0;
                                                  strcpy(tip, $2);
                                                  strcat(tip, "Array");
                                                  strcpy(id, $3);
                                                  for(i=0;i<strlen($8);i++){
                                                       if($8[i] == ','){
                                                            contor++;
                                                       }
                                                  }
                                                  contor++;
                                                  assingIntValuesToArray(id, tip, $8, contor, 1, "global");
                                              }else{
                                                  printf("Eroare la linia %d! Variabila %s este deja declarata.\n", yylineno, $3);exit(0);
                                              };}
           | CONST TIP ID '['']' ASSIGN '{' BOOL_LIST '}' {if(existsVar($3) == -1){
                                                  char tip[200];
                                                  char id[200];
                                                  int i, contor;
                                                  contor = 0;
                                                  strcpy(tip, $2);
                                                  strcat(tip, "Array");
                                                  strcpy(id, $3);
                                                  for(i=0;i<strlen($8);i++){
                                                       if($8[i] == ','){
                                                            contor++;
                                                       }
                                                  }
                                                  contor++;
                                                  assingIntValuesToArray(id, tip, $8, contor, 1, "global");
                                              }else{
                                                  printf("Eroare la linia %d! Variabila %s este deja declarata.\n", yylineno, $3);exit(0);
                                              };}   
           | TIP ID '(' lista_parametrii ')' {if(existsFunc($1, $2, $4) == -1){
                                             insertFunction($1, $2, $4);
                                        }else{
                                             printf("Eroare! Functia %s este deja declarata.", $2);
                                        };}
          | VOID ID '(' lista_parametrii')' {if(existsFunc($1, $2, $4) == -1){
                                             insertFunction($1, $2, $4);
                                        }else{
                                             printf("Eroare! Functia %s este deja declarata.", $2);
                                        };}

           | STRUCT ID  { strcpy(structs[structCounter].name, $2);strcpy(structs[structCounter].scope, "global");structCounter++;} '{' declaratii_struct '}' 
           ;

lista_parametrii  : parametru {strcat($$," "); }
                  | lista_parametrii ',' parametru { strcat($$,$3); strcat($$," ");  }
                  ;
parametru:  TIP ID {strcat($$, " ");strcat($$, $2);};
declaratii_struct : declaratie_struct
                  | declaratii_struct ',' declaratie_struct
                  ;
declaratie_struct : TIP ID {if(existsVar($2) == -1 && existsStruct($2) == -1){
                         char tip[200];
                         char id[200];
                         strcpy(tip, $1);
                         strcpy(id, $2);
                         declareStructValue(id, tip, false, 0, "", ' ', 0);
                    }else{
                         printf("Eroare la linia %d! Variabila %s este deja declarata.\n", yylineno, $2);
                         exit(0);
                    };}
           | TIP ID '[' NR ']' {if(existsVar($2) == -1){
                                   char tip[200];
                                   char id[200];
                                   int dimension = $4;
                                   strcpy(tip, $1);
                                   strcat(tip, "Array");
                                   strcpy(id, $2);
                                   declareStructArray(id, tip, dimension);
                              }else{
                                   printf("Eroare la linia %d! Variabila %s este deja declarata.\n", yylineno, $2);exit(0);
                    };} 
           | TIP ID '(' lista_parametrii ')' {if(existsFunc($1, $2, $4) == -1){
                                             insertFunction($1, $2, $4);
                                        }else{
                                             printf("Eroare! Functia %s este deja declarata.", $2);
                                        };}
           | STRUCT ID  { structs[structCounter-1].substructuri[structs[structCounter-1].substructCount] = structCounter + structs[structCounter].substructCount;
                         strcpy(structs[structCounter + structs[structCounter].substructCount].name, $2); 
                         structs[structCounter-1].substructCount = structs[structCounter-1].substructCount +1;structCounter++;} '{' declaratii_struct '}' 
           ;       
/* bloc */
bloc : BGIN list END  
     ;
/* lista instructiuni */
list :  statement ';' 
     | list statement ';'
     ; 
/* instructiune */
statement: ID ASSIGN ID { 
                              if (existsVar($1)!=-1 && existsVar($3)!=-1){
                                   if (strcmp(vars[existsVar($1)].type, vars[existsVar($3)].type) == 0){ //Daca au acelasi tip
                                        if (!vars[existsVar($1)].isConst && vars[existsVar($3)].isInit){
                                             if (strcmp(vars[existsVar($1)].type, "int") == 0) vars[existsVar($1)].intVal = vars[existsVar($3)].intVal;
                                             else if (strcmp(vars[existsVar($1)].type, "bool") == 0) vars[existsVar($1)].boolVal = vars[existsVar($3)].boolVal;
                                             else if (strcmp(vars[existsVar($1)].type, "char") == 0) vars[existsVar($1)].charVal = vars[existsVar($3)].charVal;
                                             else if (strcmp(vars[existsVar($1)].type, "float") == 0) vars[existsVar($1)].floatVal = vars[existsVar($3)].floatVal;
                                             else if (strcmp(vars[existsVar($1)].type, "intArray") == 0) {
                                                  vars[existsVar($1)].intArrayVal = vars[existsVar($3)].intArrayVal;
                                                  vars[existsVar($1)].arraySize = vars[existsVar($3)].arraySize;
                                             }
                                             else if (strcmp(vars[existsVar($1)].type, "boolArray") == 0) {
                                                  vars[existsVar($1)].boolArrayVal = vars[existsVar($3)].boolArrayVal;
                                                  vars[existsVar($1)].arraySize = vars[existsVar($3)].arraySize;
                                             }
                                             else if (strcmp(vars[existsVar($1)].type, "floatArray") == 0) {
                                                  vars[existsVar($1)].floatArrayVal = vars[existsVar($3)].floatArrayVal;
                                                  vars[existsVar($1)].arraySize = vars[existsVar($3)].arraySize;
                                             }
                                             else if (strcmp(vars[existsVar($1)].type, "string") == 0) {
                                                  strcpy(vars[existsVar($1)].strVal, vars[existsVar($3)].strVal);
                                                  vars[existsVar($1)].arraySize = vars[existsVar($3)].arraySize;
                                             }
                                        }
                                        else {printf("Eroare la linia %d! Variabila %s este const sau variabila %s nu este initializata.\n", yylineno, $1, $3);exit(0);}
                                   }
                                   else {printf("Eroare la linia %d! Variabilele %s si %s au tipuri diferite.\n", yylineno, $1, $3);exit(0);}
                              }
                              else {printf("Eroare la linia %d! Variabila %s sau variabila %s nu sunt declarate.\n", yylineno, $1, $3);exit(0);}
          }
          | ID ASSIGN ID'.'ID{
                              if (existsVar($1) != -1){
                                   if (!vars[existsVar($1)].isConst){
                                        if (existsStruct($3) != -1){
                                             int i;
                                             for(i=0;i<structs[existsStruct($3)].memberCount;i++){
                                                  if (strcmp(structs[existsStruct($3)].membri[i].name, $5) == 0){
                                                       if(strcmp(structs[existsStruct($3)].membri[i].type, vars[existsVar($1)].type) == 0){
                                                            if (strcmp(vars[existsVar($1)].type, "int") == 0) vars[existsVar($1)].intVal = structs[existsStruct($3)].membri[i].intVal;
                                                            else if (strcmp(vars[existsVar($1)].type, "bool") == 0) vars[existsVar($1)].boolVal = structs[existsStruct($3)].membri[i].boolVal;
                                                            else if (strcmp(vars[existsVar($1)].type, "char") == 0) vars[existsVar($1)].charVal = structs[existsStruct($3)].membri[i].charVal;
                                                            else if (strcmp(vars[existsVar($1)].type, "float") == 0) vars[existsVar($1)].floatVal = structs[existsStruct($3)].membri[i].floatVal;
                                                            else if (strcmp(vars[existsVar($1)].type, "intArray") == 0) {
                                                                 vars[existsVar($1)].intArrayVal = structs[existsStruct($3)].membri[i].intArrayVal;
                                                                 vars[existsVar($1)].arraySize = structs[existsStruct($3)].membri[i].arraySize;
                                                            }
                                                            else if (strcmp(vars[existsVar($1)].type, "boolArray") == 0) {
                                                                 vars[existsVar($1)].boolArrayVal = structs[existsStruct($3)].membri[i].boolArrayVal;
                                                                 vars[existsVar($1)].arraySize = structs[existsStruct($3)].membri[i].arraySize;
                                                            }
                                                            else if (strcmp(vars[existsVar($1)].type, "floatArray") == 0) {
                                                                 vars[existsVar($1)].floatArrayVal = structs[existsStruct($3)].membri[i].floatArrayVal;
                                                                 vars[existsVar($1)].arraySize = structs[existsStruct($3)].membri[i].arraySize;
                                                            }
                                                            else if (strcmp(vars[existsVar($1)].type, "string") == 0) {
                                                                 strcpy(vars[existsVar($1)].strVal, structs[existsStruct($3)].membri[i].strVal);
                                                                 vars[existsVar($1)].arraySize = structs[existsStruct($3)].membri[i].arraySize;
                                                            }
                                                       }
                                                       else {printf("Eroare la linia %d! Variabilele %s si %s au tipuri diferite.\n", yylineno, $1, $3);exit(0);}
                                                  }
                                                  else {printf("Eroare la linia %d! Variabila %s nu sunt declarata.\n", yylineno, $5);exit(0);}
                                             }
                                        }
                                        else {printf("Eroare la linia %d! Variabila %s nu sunt declarata.\n", yylineno, $3);exit(0);}
                                   }
                                   else {printf("Eroare la linia %d! Variabila %s este const.\n", yylineno, $1);exit(0);}
                              }
          }
          | ID PLUSPLUS {
               if (existsVar($1) != -1){
                    if (strcmp(vars[existsVar($1)].type, "int") == 0){
                         if (!vars[existsVar($1)].isConst){
                              vars[existsVar($1)].intVal = vars[existsVar($1)].intVal + 1;
                         }
                         else {printf("Eroare la linia %d! Variabila %s este const.\n", yylineno, $1);exit(0);}
                    }
                    else {printf("Eroare la linia %d! Nu se poate aplica ++.\n", yylineno);exit(0);} 
               }
               else {printf("Eroare la linia %d! Variabila %s nu este declarata.\n", yylineno, $1);exit(0);}
          }
          | ID MINUSMINUS {
               if (existsVar($1) != -1){
                    if (strcmp(vars[existsVar($1)].type, "int") == 0){
                         if (!vars[existsVar($1)].isConst){
                              vars[existsVar($1)].intVal = vars[existsVar($1)].intVal - 1;
                         }
                         else {printf("Eroare la linia %d! Variabila %s este const.\n", yylineno, $1);exit(0);}
                    }
                    else {printf("Eroare la linia %d! Nu se poate aplica --.\n", yylineno);exit(0);} 
               }
               else {printf("Eroare la linia %d! Variabila %s nu este declarata.\n", yylineno, $1);exit(0);}
          }
          | ID ASSIGN NR {
                              if (existsVar($1) != -1){
                                   if (strcmp(vars[existsVar($1)].type, "int") == 0){
                                        if (!vars[existsVar($1)].isConst){
                                             vars[existsVar($1)].intVal = $3;
                                             vars[existsVar($1)].isInit = 1;
                                        }
                                        else {printf("Eroare la linia %d! Variabila %s este const.\n", yylineno, $1);exit(0);}
                                   }
                                   else {printf("Eroare la linia %d! Tipuri diferite.\n", yylineno);exit(0);}
                              }
                              else {printf("Eroare la linia %d! Variabila %s nu este declarata.\n", yylineno, $1);exit(0);}
         }
         | ID ASSIGN BOOL {
                              if (existsVar($1) != -1){
                                   if (strcmp(vars[existsVar($1)].type, "bool") == 0){
                                        if (!vars[existsVar($1)].isConst){
                                             if ($3 = true) vars[existsVar($1)].boolVal = true;
                                             else vars[existsVar($1)].boolVal = false;
                                             vars[existsVar($1)].isInit = 1;
                                        }
                                        else {printf("Eroare la linia %d! Variabila %s este const.\n", yylineno, $1);exit(0);}
                                   }
                                   else {printf("Eroare la linia %d! Tipuri diferite.\n", yylineno);exit(0);}
                              }
                              else {printf("Eroare la linia %d! Variabila %s nu este declarata.\n", yylineno, $1);exit(0);}
         }
         | ID ASSIGN CHAR {
                              if (existsVar($1)!=-1){
                                   if (strcmp(vars[existsVar($1)].type, "char") == 0){
                                        if (!vars[existsVar($1)].isConst){
                                              vars[existsVar($1)].charVal = $3;
                                              vars[existsVar($1)].isInit = 1;
                                        }
                                        else {printf("Eroare la linia %d! Variabila %s este const.\n", yylineno, $1);exit(0);}
                                   }
                                   else {printf("Eroare la linia %d! Tipuri diferite.\n", yylineno);exit(0);}
                              }
                              else {printf("Eroare la linia %d! Variabila %s nu este declarata.\n", yylineno, $1);exit(0);}
         }
         | ID ASSIGN FLOAT {
                              if (existsVar($1)!=-1){
                                   if (strcmp(vars[existsVar($1)].type, "float") == 0){
                                        if (!vars[existsVar($1)].isConst){
                                              vars[existsVar($1)].floatVal = $3;
                                              vars[existsVar($1)].isInit = 1;
                                        }
                                        else {printf("Eroare la linia %d! Variabila %s este const.\n", yylineno, $1);exit(0);}
                                   }
                                   else {printf("Eroare la linia %d! Tipuri diferite.\n", yylineno);exit(0);}
                              }
                              else {printf("Eroare la linia %d! Variabila %s nu este declarata.\n", yylineno, $1);exit(0);}
         }
         | ID ASSIGN '{' INT_LIST '}' {
                              if (existsVar($1)!=-1){
                                   if (strcmp(vars[existsVar($1)].type, "intArray") == 0){
                                        if (!vars[existsVar($1)].isConst){
                                             char tip[200];
                                             char id[200];
                                             int i, contor;
                                             contor = 0;
                                             strcat(tip, "int");
                                             strcat(tip, "Array");
                                             vars[existsVar($1)].isInit = 1;
                                             strcpy(id, vars[existsVar($1)].name);
                                             for(i=0;i<strlen($4);i++){
                                                  if($4[i] == ','){
                                                       contor++;
                                                  }
                                             }
                                             contor++;
                                             assingIntValuesToArray(id, tip, $4, contor, 0, "global");
                                        }
                                        else {printf("Eroare la linia %d! Variabila %s este const.\n", yylineno, $1);exit(0);}
                                   }
                                   else {printf("Eroare la linia %d! Tipuri diferite.\n", yylineno);exit(0);}
                              }
                              else {printf("Eroare la linia %d! Variabila %s nu este declarata.\n", yylineno, $1);exit(0);}
         }
         | ID ASSIGN '{' FLOAT_LIST '}' {
                              if (existsVar($1)!=-1){
                                   if (strcmp(vars[existsVar($1)].type, "floatArray") == 0){
                                        if (!vars[existsVar($1)].isConst){
                                             char tip[200];
                                             char id[200];
                                             int i, contor;
                                             contor = 0;
                                             strcat(tip, "float");
                                             strcat(tip, "Array");
                                             vars[existsVar($1)].isInit = 1;
                                             strcpy(id, vars[existsVar($1)].name);
                                             for(i=0;i<strlen($4);i++){
                                                  if($4[i] == ','){
                                                       contor++;
                                                  }
                                             }
                                             contor++;
                                             assingIntValuesToArray(id, tip, $4, contor, 0, "global");
                                        }
                                        else {printf("Eroare la linia %d! Variabila %s este const.\n", yylineno, $1);exit(0);}
                                   }
                                   else {printf("Eroare la linia %d! Tipuri diferite.\n", yylineno);exit(0);}
                              }
                              else {printf("Eroare la linia %d! Variabila %s nu este declarata.\n", yylineno, $1);exit(0);}
         }
         | ID ASSIGN '{' BOOL_LIST '}' {
                              if (existsVar($1)!=-1){
                                   if (strcmp(vars[existsVar($1)].type, "boolArray") == 0){
                                        if (!vars[existsVar($1)].isConst){
                                             char tip[200];
                                             char id[200];
                                             int i, contor;
                                             contor = 0;
                                             strcat(tip, "bool");
                                             strcat(tip, "Array");
                                             vars[existsVar($1)].isInit = 1;
                                             strcpy(id, vars[existsVar($1)].name);
                                             for(i=0;i<strlen($4);i++){
                                                  if($4[i] == ','){
                                                       contor++;
                                                  }
                                             }
                                             contor++;
                                             assingIntValuesToArray(id, tip, $4, contor, 0, "global");
                                        }
                                        else {printf("Eroare la linia %d! Variabila %s este const.\n", yylineno, $1);exit(0);}
                                   }
                                   else {printf("Eroare la linia %d! Tipuri diferite.\n", yylineno);exit(0);}
                              }
                              else {printf("Eroare la linia %d! Variabila %s nu este declarata.\n", yylineno, $1);exit(0);}
         }
         | ID ASSIGN CUVANT {
                              if (existsVar($1)!=-1){
                                   if (strcmp(vars[existsVar($1)].type, "string") == 0){
                                        if (!vars[existsVar($1)].isConst){
                                             strcpy(vars[existsVar($1)].strVal, $3);
                                             vars[existsVar($1)].isInit = 1;
                                        }
                                        else {printf("Eroare la linia %d! Variabila %s este const.\n", yylineno, $1);exit(0);}
                                   }
                                   else {printf("Eroare la linia %d! Tipuri diferite.\n", yylineno);exit(0);}
                              }
                              else {printf("Eroare la linia %d! Variabila %s nu este declarata.\n", yylineno, $1);exit(0);}
         }
         | ID '[' NR ']' ASSIGN ID {
                              if (existsVar($1)!=-1 && existsVar($6)!=-1){
                                   char temp[200];
                                   strcpy(temp, vars[existsVar($6)].type);
                                   strcat(temp, "Array");
                                   if (strcmp(vars[existsVar($1)].type, temp) == 0){ //Daca au acelasi tip
                                        if (!vars[existsVar($1)].isConst){
                                             vars[existsVar($1)].isInit = 1;
                                             if ($3 < vars[existsVar($1)].arraySize){
                                                  if (strcmp(vars[existsVar($6)].type, "int") == 0) vars[existsVar($1)].intArrayVal[$3] = vars[existsVar($6)].intVal;
                                                  else if (strcmp(vars[existsVar($6)].type, "bool") == 0) vars[existsVar($1)].boolArrayVal[$3] = vars[existsVar($6)].boolVal;
                                                  else if (strcmp(vars[existsVar($6)].type, "char") == 0) vars[existsVar($1)].strVal[$3] = vars[existsVar($6)].charVal;
                                                  else if (strcmp(vars[existsVar($6)].type, "float") == 0) vars[existsVar($1)].floatArrayVal[$3] = vars[existsVar($6)].floatVal;
                                             }
                                        }
                                        else {printf("Eroare la linia %d! Variabila %s este const.\n", yylineno, $1);exit(0);}
                                   }
                                   else {printf("Eroare la linia %d! Variabilele %s si %s au tipuri diferite.\n", yylineno, $1, $6);exit(0);}
                              }
                              else {printf("Eroare la linia %d! Variabila %s sau variabila %s nu sunt declarate.\n", yylineno, $1, $6);exit(0);}
          }
         | ID '[' NR ']' PLUSPLUS{
                              if (existsVar($1)!=-1){
                                   char temp[200];
                                   if (strcmp(vars[existsVar($1)].type, "intArray") == 0){ //Daca au acelasi tip
                                        if (!vars[existsVar($1)].isConst){
                                             if ($3 < vars[existsVar($1)].arraySize){
                                                  vars[existsVar($1)].intArrayVal[$3] ++ ;
                                                  vars[existsVar($1)].isInit = 1;
                                             }
                                             else {printf("Eroare la linia %d! Index out of bounds.\n", yylineno);exit(0);}
                                        }
                                        else {printf("Eroare la linia %d! Variabila %s este const.\n", yylineno, $1);exit(0);}
                                   }
                                   else {printf("Eroare la linia %d! Tipuri diferite.\n", yylineno);exit(0);}
                              }
                              else {printf("Eroare la linia %d! Variabila %s nu este declarata.\n", yylineno, $1);exit(0);}
          }
          | ID '[' NR ']' MINUSMINUS{
                              if (existsVar($1)!=-1){
                                   char temp[200];
                                   if (strcmp(vars[existsVar($1)].type, "intArray") == 0){ //Daca au acelasi tip
                                        if (!vars[existsVar($1)].isConst){
                                             if ($3 < vars[existsVar($1)].arraySize){
                                                  vars[existsVar($1)].intArrayVal[$3] -- ;
                                                  vars[existsVar($1)].isInit = 1;
                                             }
                                             else {printf("Eroare la linia %d! Index out of bounds.\n", yylineno);exit(0);}
                                        }
                                        else {printf("Eroare la linia %d! Variabila %s este const.\n", yylineno, $1);exit(0);}
                                   }
                                   else {printf("Eroare la linia %d! Tipuri diferite.\n", yylineno);exit(0);}
                              }
                              else {printf("Eroare la linia %d! Variabila %s nu este declarata.\n", yylineno, $1);exit(0);}
          }
         | ID '[' NR ']' ASSIGN NR{
                              if (existsVar($1)!=-1){
                                   char temp[200];
                                   if (strcmp(vars[existsVar($1)].type, "intArray") == 0){ //Daca au acelasi tip
                                        if (!vars[existsVar($1)].isConst){
                                             if ($3 < vars[existsVar($1)].arraySize){
                                                  vars[existsVar($1)].intArrayVal[$3] = $6;
                                                  vars[existsVar($1)].isInit = 1;
                                             }
                                             else {printf("Eroare la linia %d! Index out of bounds.\n", yylineno);exit(0);}
                                        }
                                        else {printf("Eroare la linia %d! Variabila %s este const.\n", yylineno, $1);exit(0);}
                                   }
                                   else {printf("Eroare la linia %d! Tipuri diferite.\n", yylineno);exit(0);}
                              }
                              else {printf("Eroare la linia %d! Variabila %s nu este declarata.\n", yylineno, $1);exit(0);}
          }
         | ID '[' NR ']' ASSIGN BOOL{
                              if (existsVar($1)!=-1){
                                   char temp[200];
                                   if (strcmp(vars[existsVar($1)].type, "boolArray") == 0){ //Daca au acelasi tip
                                        if (!vars[existsVar($1)].isConst){
                                             if ($3 < vars[existsVar($1)].arraySize){
                                                  vars[existsVar($1)].boolArrayVal[$3] = $6;
                                                  vars[existsVar($1)].isInit = 1;
                                             }
                                             else {printf("Eroare la linia %d! Index out of bounds.\n", yylineno);exit(0);}
                                        }
                                        else {printf("Eroare la linia %d! Variabila %s este const.\n", yylineno, $1);exit(0);}
                                   }
                                   else {printf("Eroare la linia %d! Tipuri diferite.\n", yylineno);exit(0);}
                              }
                              else {printf("Eroare la linia %d! Variabila %s nu este declarata.\n", yylineno, $1);exit(0);}
          }
         | ID '[' NR ']' ASSIGN CHAR{
                              if (existsVar($1)!=-1){
                                   char temp[200];
                                   if (strcmp(vars[existsVar($1)].type, "string") == 0){ //Daca au acelasi tip
                                        if (!vars[existsVar($1)].isConst){
                                             if ($3 < strlen(vars[existsVar($1)].strVal)){
                                                  vars[existsVar($1)].strVal[$3] = $6;
                                                  vars[existsVar($1)].isInit = 1;
                                             }
                                             else {printf("Eroare la linia %d! Index out of bounds.\n", yylineno);exit(0);}
                                        }
                                        else {printf("Eroare la linia %d! Variabila %s este const.\n", yylineno, $1);exit(0);}
                                   }
                                   else {printf("Eroare la linia %d! Tipuri diferite.\n", yylineno);exit(0);}
                              }
                              else {printf("Eroare la linia %d! Variabila %s nu este declarata.\n", yylineno, $1);exit(0);}
          }
         | ID '[' NR ']' ASSIGN FLOAT {
                              if (existsVar($1)!=-1){
                                   char temp[200];
                                   if (strcmp(vars[existsVar($1)].type, "floatArray") == 0){ //Daca au acelasi tip
                                        if (!vars[existsVar($1)].isConst){
                                             if ($3 < vars[existsVar($1)].arraySize){
                                                  vars[existsVar($1)].floatArrayVal[$3] = $6;
                                                  vars[existsVar($1)].isInit = 1;
                                             }
                                             else {printf("Eroare la linia %d! Index out of bounds.\n", yylineno);exit(0);}
                                        }
                                        else {printf("Eroare la linia %d! Variabila %s este const.\n", yylineno, $1);exit(0);}
                                   }
                                   else {printf("Eroare la linia %d! Tipuri diferite.\n", yylineno);exit(0);}
                              }
                              else {printf("Eroare la linia %d! Variabila %s nu este declarata.\n", yylineno, $1);exit(0);}
          }
         | ID '[' NR ']' ASSIGN ID'.'ID{
                              if (existsVar($1) != -1){
                                   if (!vars[existsVar($1)].isConst){
                                        char temp1[200], * temp;
                                        strcpy(temp1, vars[existsVar($1)].type);
                                        temp = strtok(temp1, "A");
                                        if (existsStruct($6) != -1){
                                             int i;
                                             for(i=0;i<structs[existsStruct($6)].memberCount;i++){
                                                  if (strcmp(structs[existsStruct($6)].membri[i].name, $6) == 0){
                                                       if(strcmp(structs[existsStruct($6)].membri[i].type, temp) == 0){
                                                            if (vars[existsVar($1)].arraySize <= $3){
                                                                 vars[existsVar($1)].isInit = 1;
                                                                 if (strcmp(vars[existsVar($1)].type, "intArray") == 0) vars[existsVar($1)].intArrayVal[$3] = structs[existsStruct($6)].membri[i].intVal;
                                                                 else if (strcmp(vars[existsVar($1)].type, "boolArray") == 0) vars[existsVar($1)].boolArrayVal[$3] = structs[existsStruct($6)].membri[i].boolVal;
                                                                 else if (strcmp(vars[existsVar($1)].type, "string") == 0) {
                                                                      if (strlen(vars[existsVar($1)].strVal) <= $3) vars[existsVar($1)].strVal[$3] = structs[existsStruct($6)].membri[i].charVal;
                                                                      else {printf("Eroare la linia %d! Index out of bounds.\n", yylineno);exit(0);}
                                                                 }
                                                                 else if (strcmp(vars[existsVar($1)].type, "floatArray") == 0) vars[existsVar($1)].floatArrayVal[$3] = structs[existsStruct($6)].membri[i].floatVal;
                                                            }
                                                            else {printf("Eroare la linia %d! Index out of bounds.\n", yylineno);exit(0);}
                                                       }
                                                       else {printf("Eroare la linia %d! Variabilele %s si %s au tipuri diferite.\n", yylineno, $1, $6);exit(0);}
                                                  }
                                                  else {printf("Eroare la linia %d! Variabila %s nu sunt declarata.\n", yylineno, $6);exit(0);}
                                             }
                                        }
                                        else {printf("Eroare la linia %d! Variabila %s nu sunt declarata.\n", yylineno, $6);exit(0);}
                                   }
                                   else {printf("Eroare la linia %d! Variabila %s este const.\n", yylineno, $1);exit(0);}
                              }
          }
         | MYIF '(' EXP ')' '{' statement '}' {
              if (strcmp($3->type, "bool") != 0){ //Adica expresia nu este potrivita
                    printf("Eroare la linia %d! Expresia din cadrul functiei if nu este valabila, deoarece nu este de tipul bool!\n", yylineno); // Pentru ca aceste comenzi se intint pe mai mult linii, eroarea va aparea ca fiind de la ultima linie a comenzii, desi conditia nu este indeplinita pe prima ei linie
                    exit(0);
              }
         }
         | MYWHILE '(' EXP ')' '{' list '}' {
              if (strcmp($3->type, "bool") != 0){ //Adica expresia nu este potrivita
                    printf("Eroare la linia %d! Expresia din cadrul functiei while nu este valabila, deoarece nu este de tipul bool!\n", yylineno);
                    exit(0);
              }
         }
         | MYFOR '(' statement ';' EXP ';' statement ')' '{' list '}'	{
              if (strcmp($5->type, "bool") != 0){ //Adica expresia nu este potrivita
                    printf("Eroare la linia %d! Expresia din cadrul functiei for nu este valabila, deoarece nu este de tipul bool!\n", yylineno);
                    exit(0);
              }
         }
         | PRINT '(' CUVANT ')' {
              char temp[200];
              strcpy(temp, $3);
              temp[strlen(temp)] = '\0';
              temp[strlen(temp)-1] = '\0';
              temp[strlen(temp)+1] = '\0';
              for (int i=0;i<strlen($3)-1;i++){
                   temp[i] = temp[i+1];
              }
              printf("%s\n", temp);
         }
         | PRINT '(' CUVANT ',' NR ')' {
              char temp[200];
              strcpy(temp, $3);
              temp[strlen(temp)] = '\0';
              temp[strlen(temp)-1] = '\0';
              temp[strlen(temp)+1] = '\0';
              for (int i=0;i<strlen($3)-1;i++){
                   temp[i] = temp[i+1];
              }
              printf("%s %d\n", temp, $5);
         }
         | PRINT '(' CUVANT ',' FLOAT ')' {
              char temp[200];
              strcpy(temp, $3);
              temp[strlen(temp)] = '\0';
              temp[strlen(temp)-1] = '\0';
              temp[strlen(temp)+1] = '\0';
              for (int i=0;i<strlen($3)-1;i++){
                   temp[i] = temp[i+1];
              }
              printf("%s %f\n", temp, $5);
         }
         | PRINT '(' CUVANT ',' BOOL ')' {
              char temp[200];
              strcpy(temp, $3);
              temp[strlen(temp)] = '\0';
              temp[strlen(temp)-1] = '\0';
              temp[strlen(temp)+1] = '\0';
              for (int i=0;i<strlen($3)-1;i++){
                   temp[i] = temp[i+1];
              }
              printf("%s %d\n", temp, $5);
         }
         | PRINT '(' CUVANT ',' EXP ')' {
              char temp[200];
              strcpy(temp, $3);
              temp[strlen(temp)] = '\0';
              temp[strlen(temp)-1] = '\0';
              temp[strlen(temp)+1] = '\0';
              for (int i=0;i<strlen($3)-1;i++){
                   temp[i] = temp[i+1];
              }
              if (strcmp($5->type, "int") == 0){
                   printf("%s %d\n", temp, $5->intVal);
              }
              else if (strcmp($5->type, "bool") == 0){
                   printf("%s %d\n", temp, $5->boolVal);
              }
              else if (strcmp($5->type, "float") == 0){
                   printf("%s %f\n", temp, $5->floatVal);
              }
         }
         | ID '(' lista_parametrii ')' {if(existsFunctieInBody($1, $3) == -1){
                                             printf("Eroare! Functia %s nu este declarata.\n", $1);
                                             exit(0);
                                        }
         }
         | ID ASSIGN ID '(' lista_parametrii ')' {
                              if (existsVar($1) != -1){
                                   if(existsFunctieInBody($3, $5) != -1){
                                        if (strcmp(vars[existsVar($1)].type, functions[existsFunctieInBody($3, $5)].type) == 0){
                                             if (!vars[existsVar($1)].isConst){
                                                  vars[existsVar($1)].isInit = 1;
                                                  printf("Functie apelata cu succes!\n");
                                             }
                                             else {printf("Eroare la linia %d! Variabila %s este const.\n", yylineno, $1);exit(0);}
                                        }
                                        else {printf("Eroare la linia %d! Tipuri diferite.\n", yylineno);exit(0);}
                                   }
                                   else {printf("Eroare! Functia %s nu este declarata.\n", $1);exit(0);}
                              }
                              else {printf("Eroare la linia %d! Variabila %s nu este declarata.\n", yylineno, $1);exit(0);}
         }
         | ID '[' NR ']' ASSIGN ID '(' lista_parametrii ')' {
                              if (existsVar($1)!=-1 && existsFunctieInBody($6, $8) != -1){
                                   char temp[200];
                                   strcpy(temp, vars[existsVar($6)].type);
                                   strcat(temp, "Array");
                                   if (strcmp(functions[existsFunctieInBody($6, $8)].type, temp) == 0){ //Daca au acelasi tip
                                        if (!vars[existsVar($1)].isConst){
                                             printf("Functie apelata cu succes!\n");
                                             vars[existsVar($1)].isInit = 1;
                                        }
                                        else {printf("Eroare la linia %d! Variabila %s este const.\n", yylineno, $1);exit(0);}
                                   }
                                   else {printf("Eroare la linia %d! Variabilele %s si %s au tipuri diferite.\n", yylineno, $1, $6);exit(0);}
                              }
                              else {printf("Eroare la linia %d! Variabila %s sau variabila %s nu sunt declarate.\n", yylineno, $1, $6);exit(0);}
          }
          | TIP ID {if(existsVar($2) == -1){
                         char tip[200];
                         char id[200];
                         strcpy(tip, $1);
                         strcpy(id, $2);
                         declareValue(id, tip, false, 0, "", ' ', 0, "main_function", 0);
                    }else{
                         printf("Eroare la linia %d! Variabila %s este deja declarata.\n", yylineno, $2);
                         exit(0);
                    };}
           | CONST TIP ID {printf("Eroare la linia %d! Trebuie declarata valoarea constantei.\n", yylineno);exit(0);}
           | CONST TIP ID ASSIGN NR {if(existsVar($3) == -1){
                                   if (strcmp($2, "int") == 0){
                                        char tip[200];
                                        char id[200];
                                        strcpy(tip, $2);
                                        strcpy(id, $3);
                                        declareValue(id, tip, true, $5, "", ' ', 0, "main_function", 1);
                                   }
                                   else {printf("Eroare la linia %d! Tipul variabilei %s nu se potriveste.\n", yylineno, $2);exit(0);}
                                 }else{
                                   printf("Eroare la linia %d! Variabila %s este deja declarata.\n", yylineno, $2);exit(0);
                    };}
          | CONST TIP ID ASSIGN FLOAT {if(existsVar($3) == -1){
                                   if (strcmp($2, "float") == 0){
                                        char tip[200];
                                        char id[200];
                                        strcpy(tip, $2);
                                        strcpy(id, $3);
                                        declareValue(id, tip, true, 0, "", ' ', $5, "main_function", 1);
                                   }
                                   else {printf("Eroare la linia %d! Tipul variabilei %s nu se potriveste.\n", yylineno, $2);exit(0);}
                                 }else{
                                   printf("Eroare la linia %d! Variabila %s este deja declarata.\n", yylineno, $2);exit(0);
                    };}
           | CONST TIP ID ASSIGN CHAR {
                              if(existsVar($3) == -1){
                                   char tip[200];
                                   char id[200];
                                   if (strcmp($2, "char") == 0){
                                        strcpy(tip, $2);
                                        strcpy(id, $3);
                                        declareValue(id, tip, true, 0, "", $5, 0, "main_function", 1);
                                   }
                                   else {printf("Eroare la linia %d! Tipul variabilei %s nu se potriveste.\n", yylineno, $3);exit(0);}
                              }else{
                                   printf("Eroare la linia %d! Variabila %s este deja declarata.\n", yylineno, $3);exit(0);
                    };}
           | CONST TIP ID ASSIGN CUVANT {if(existsVar($3) == -1){
                                   char tip[200];
                                   char id[200];
                                   if (strcmp($2, "string") == 0){
                                        strcpy(tip, $2);
                                        strcpy(id, $3);
                                        declareValue(id, tip, true, 0, $5, ' ', 0, "main_function", 1);
                                   }
                                   else if (strcmp($2, "char") == 0 && strlen($5) >= 1){
                                        strcpy(tip, $2);
                                        strcpy(id, $3);
                                        declareValue(id, tip, true, 0, "", $5[0], 0, "main_function", 1);
                                   }
                                   else {printf("Eroare la linia %d! Tipul variabilei %s nu se potriveste.\n", yylineno, $3);exit(0);}
                                 }else{
                                   printf("Eroare la linia %d! Variabila %s este deja declarata.\n", yylineno, $3);exit(0);
                    };}
           | TIP ID '[' NR ']' {if(existsVar($2) == -1){
                                   char tip[200];
                                   char id[200];
                                   int dimension = $4;
                                   strcpy(tip, $1);
                                   strcat(tip, "Array");
                                   strcpy(id, $2);
                                   declareArray(id, tip, dimension, "main_function");
                              }else{
                                   printf("Eroare la linia %d! Variabila %s este deja declarata.\n", yylineno, $2);exit(0);
                    };}
           | TIP ID '['']' ASSIGN '{' INT_LIST '}' {if(existsVar($2) == -1){
                                                  char tip[200];
                                                  char id[200];
                                                  int i, contor;
                                                  contor = 0;
                                                  strcpy(tip, $1);
                                                  strcat(tip, "Array");
                                                  strcpy(id, $2);
                                                  vars[existsVar($2)].isInit = 1;
                                                  for(i=0;i<strlen($7);i++){
                                                       if($7[i] == ','){
                                                            contor++;
                                                       }
                                                  }
                                                  contor++;
                                                  assingIntValuesToArray(id, tip, $7, contor, 0, "main_function");
                                              }else{
                                                  printf("Eroare la linia %d! Variabila %s este deja declarata.\n", yylineno, $2);exit(0);
                                              };}
           | TIP ID '['']' ASSIGN '{' FLOAT_LIST '}' {if(existsVar($2) == -1){
                                                  char tip[200];
                                                  char id[200];
                                                  int i, contor;
                                                  contor = 0;
                                                  strcpy(tip, $1);
                                                  strcat(tip, "Array");
                                                  strcpy(id, $2);
                                                  vars[existsVar($2)].isInit = 1;
                                                  for(i=0;i<strlen($7);i++){
                                                       if($7[i] == ','){
                                                            contor++;
                                                       }
                                                  }
                                                  contor++;
                                                  assingIntValuesToArray(id, tip, $7, contor, 0, "main_function");
                                              }else{
                                                  printf("Eroare la linia %d! Variabila %s este deja declarata.\n", yylineno, $2);exit(0);
                                              };}
           | TIP ID '['']' ASSIGN '{' BOOL_LIST '}' {if(existsVar($2) == -1){
                                                  char tip[200];
                                                  char id[200];
                                                  int i, contor;
                                                  contor = 0;
                                                  strcpy(tip, $1);
                                                  strcat(tip, "Array");
                                                  strcpy(id, $2);
                                                  vars[existsVar($2)].isInit = 1;
                                                  for(i=0;i<strlen($7);i++){
                                                       if($7[i] == ','){
                                                            contor++;
                                                       }
                                                  }
                                                  contor++;
                                                  assingIntValuesToArray(id, tip, $7, contor, 0, "main_function");
                                              }else{
                                                  printf("Eroare la linia %d! Variabila %s este deja declarata.\n", yylineno, $2);exit(0);
                                              };}
           | CONST TIP ID '['']' ASSIGN '{' INT_LIST '}' {if(existsVar($3) == -1){
                                                  char tip[200];
                                                  char id[200];
                                                  int i, contor;
                                                  contor = 0;
                                                  strcpy(tip, $2);
                                                  strcat(tip, "Array");
                                                  strcpy(id, $3);
                                                  for(i=0;i<strlen($8);i++){
                                                       if($8[i] == ','){
                                                            contor++;
                                                       }
                                                  }
                                                  contor++;
                                                  assingIntValuesToArray(id, tip, $8, contor, 1, "main_function");
                                              }else{
                                                  printf("Eroare la linia %d! Variabila %s este deja declarata.\n", yylineno, $3);exit(0);
                                              };}
           | CONST TIP ID '['']' ASSIGN '{' FLOAT_LIST '}' {if(existsVar($3) == -1){
                                                  char tip[200];
                                                  char id[200];
                                                  int i, contor;
                                                  contor = 0;
                                                  strcpy(tip, $2);
                                                  strcat(tip, "Array");
                                                  strcpy(id, $3);
                                                  for(i=0;i<strlen($8);i++){
                                                       if($8[i] == ','){
                                                            contor++;
                                                       }
                                                  }
                                                  contor++;
                                                  assingIntValuesToArray(id, tip, $8, contor, 1, "main_function");
                                              }else{
                                                  printf("Eroare la linia %d! Variabila %s este deja declarata.\n", yylineno, $3);exit(0);
                                              };}
           | CONST TIP ID '['']' ASSIGN '{' BOOL_LIST '}' {if(existsVar($3) == -1){
                                                  char tip[200];
                                                  char id[200];
                                                  int i, contor;
                                                  contor = 0;
                                                  strcpy(tip, $2);
                                                  strcat(tip, "Array");
                                                  strcpy(id, $3);
                                                  for(i=0;i<strlen($8);i++){
                                                       if($8[i] == ','){
                                                            contor++;
                                                       }
                                                  }
                                                  contor++;
                                                  assingIntValuesToArray(id, tip, $8, contor, 1, "main_function");
                                              }else{
                                                  printf("Eroare la linia %d! Variabila %s este deja declarata.\n", yylineno, $3);exit(0);
                                              };}   
           | TIP ID '(' lista_parametrii ')' {if(existsFunc($1, $2, $4) == -1){
                                             insertFunction($1, $2, $4);
                                        }else{
                                             printf("Eroare! Functia %s este deja declarata.", $2);
                                        };}
          | VOID ID '(' lista_parametrii')' {if(existsFunc($1, $2, $4) == -1){
                                             insertFunction($1, $2, $4);
                                        }else{
                                             printf("Eroare! Functia %s este deja declarata.", $2);
                                        };}

           | STRUCT ID  { strcpy(structs[structCounter].name, $2);strcpy(structs[structCounter].scope, "main_function");;structCounter++;} '{' declaratii_struct '}' 
         ;
EXP : ID { $$ = createSomeExpr($1);}
    | NR { $$ = createIntExpr($1);}
    | BOOL { $$ = createBoolExpr($1);}
    | CUVANT '[' NR ']' { $$ = createCharExpr($1[$3]);}
    | FLOAT { $$ = createFloatExpr($1);}
    | ID '[' NR ']' { $$ = createSomeExpr($1);}
    | EXP PLUS EXP {
         if (strcmp($1->type, "int") == 0 && strcmp($3->type, "int") == 0){ //Daca ambele sunt int uri
               $$ = createIntExpr($1->intVal + $3->intVal);
         }
         else if (strcmp($1->type, "float") == 0 && strcmp($3->type, "float") == 0){ //Daca ambele sunt int uri
               $$ = createFloatExpr($1->floatVal + $3->floatVal);
         }
         else {printf("Eroare la linia %d! Nepotrivire de tipuri.\n", yylineno); $$ = createInvalidExpr(); exit(0);}
    }
    | EXP MINUS EXP {
         if (strcmp($1->type, "int") == 0 && strcmp($3->type, "int") == 0){ //Daca ambele sunt int uri
               $$ = createIntExpr($1->intVal - $3->intVal);
         }
         else if (strcmp($1->type, "float") == 0 && strcmp($3->type, "float") == 0){ //Daca ambele sunt int uri
               $$ = createFloatExpr($1->floatVal - $3->floatVal);
         }
         else {printf("Eroare la linia %d! Nepotrivire de tipuri.\n", yylineno); $$ = createInvalidExpr(); exit(0);}
    }
    | EXP MUL EXP {
         if (strcmp($1->type, "int") == 0 && strcmp($3->type, "int") == 0){ //Daca ambele sunt int uri
               $$ = createIntExpr($1->intVal * $3->intVal);
         }
         else if (strcmp($1->type, "float") == 0 && strcmp($3->type, "float") == 0){ //Daca ambele sunt int uri
               $$ = createFloatExpr($1->floatVal * $3->floatVal);
         }
         else {printf("Eroare la linia %d! Nepotrivire de tipuri.\n", yylineno); $$ = createInvalidExpr(); exit(0);}
    }
    | EXP DIV EXP {
         if (strcmp($1->type, "int") == 0 && strcmp($3->type, "int") == 0){ //Daca ambele sunt int uri
               $$ = createIntExpr($1->intVal / $3->intVal);
         }
         else if (strcmp($1->type, "float") == 0 && strcmp($3->type, "float") == 0){ //Daca ambele sunt int uri
               $$ = createFloatExpr($1->floatVal / $3->floatVal);
         }
         else {printf("Eroare la linia %d! Nepotrivire de tipuri.\n", yylineno); $$ = createInvalidExpr(); exit(0);}
    }
    | EXP MOD EXP {
         if (strcmp($1->type, "int") == 0 && strcmp($3->type, "int") == 0){ //Daca ambele sunt int uri
               $$ = createIntExpr($1->intVal % $3->intVal);
         }
         else {printf("Eroare la linia %d! Nepotrivire de tipuri.\n", yylineno); $$ = createInvalidExpr(); exit(0);}
    }
    | NOT EXP {
         if (strcmp($2->type, "bool") == 0){
              $$ = createBoolExpr(!$2->boolVal);
         }
         else {printf("Eroare la linia %d! Nepotrivire de tipuri.\n", yylineno); $$ = createInvalidExpr(); exit(0);}
    }
    | EXP SAU EXP {
         if (strcmp($1->type, "bool") == 0 && strcmp($3->type, "bool") == 0){ //Daca ambele sunt bool uri
               $$ = createBoolExpr($1->boolVal ||  $3->boolVal);
         }
         else {printf("Eroare la linia %d! Nepotrivire de tipuri.\n", yylineno); $$ = createInvalidExpr(); exit(0);}
    }
    | EXP SI EXP {
         if (strcmp($1->type, "bool") == 0 && strcmp($3->type, "bool") == 0){ //Daca ambele sunt bool uri
               $$ = createBoolExpr($1->boolVal &&  $3->boolVal);
         }
         else {printf("Eroare la linia %d! Nepotrivire de tipuri.\n", yylineno); $$ = createInvalidExpr(); exit(0);}
    }
    | EXP LT EXP {
         if (strcmp($1->type, "int") == 0 && strcmp($3->type, "int") == 0){ //Daca ambele sunt int uri
               $$ = createIntExpr($1->intVal < $3->intVal);
         }

         else if (strcmp($1->type, "float") == 0 && strcmp($3->type, "float") == 0){ //Daca ambele sunt int uri
               $$ = createFloatExpr($1->floatVal < $3->floatVal);
         }
         else {printf("Eroare la linia %d! Nepotrivire de tipuri.\n", yylineno); $$ = createInvalidExpr(); exit(0);}
    }
    | EXP LET EXP {
         if (strcmp($1->type, "int") == 0 && strcmp($3->type, "int") == 0){ //Daca ambele sunt int uri
               $$ = createIntExpr($1->intVal <= $3->intVal);
         }
         else if (strcmp($1->type, "float") == 0 && strcmp($3->type, "float") == 0){ //Daca ambele sunt int uri
               $$ = createFloatExpr($1->floatVal <= $3->floatVal);
         }
         else {printf("Eroare la linia %d! Nepotrivire de tipuri.\n", yylineno); $$ = createInvalidExpr(); exit(0);}
    }
    | EXP GT EXP {
         if (strcmp($1->type, "int") == 0 && strcmp($3->type, "int") == 0){ //Daca ambele sunt int uri
               $$ = createIntExpr($1->intVal > $3->intVal);
         }

         else if (strcmp($1->type, "float") == 0 && strcmp($3->type, "float") == 0){ //Daca ambele sunt int uri
               $$ = createFloatExpr($1->floatVal > $3->floatVal);
         }
         else {printf("Eroare la linia %d! Nepotrivire de tipuri.\n", yylineno); $$ = createInvalidExpr(); exit(0);}
    }
    | EXP GET EXP {
         if (strcmp($1->type, "int") == 0 && strcmp($3->type, "int") == 0){ //Daca ambele sunt int uri
               $$ = createIntExpr($1->intVal >= $3->intVal);
         }

         else if (strcmp($1->type, "float") == 0 && strcmp($3->type, "float") == 0){ //Daca ambele sunt int uri
               $$ = createFloatExpr($1->floatVal >= $3->floatVal);
         }
         else {printf("Eroare la linia %d! Nepotrivire de tipuri.\n", yylineno); $$ = createInvalidExpr(); exit(0);}
    }
    | EXP EQ EXP {
         if (strcmp($1->type, "int") == 0 && strcmp($3->type, "int") == 0){ //Daca ambele sunt int uri
               $$ = createIntExpr($1->intVal == $3->intVal);
         }

         else if (strcmp($1->type, "float") == 0 && strcmp($3->type, "float") == 0){ //Daca ambele sunt int uri
               $$ = createFloatExpr($1->floatVal == $3->floatVal);
         }
         else {printf("Eroare la linia %d! Nepotrivire de tipuri.\n", yylineno); $$ = createInvalidExpr(); exit(0);}
    }
    | '(' EXP ')' {$$ = $2;}    
%%
Expr* createSomeExpr(char* val){
     int pozitie = existsVar(val); 
     if (pozitie != -1){ //este o variabila
          if (vars[pozitie].isInit == true){
               if (strcmp(vars[pozitie].type, "int") == 0) { return createIntExpr(vars[pozitie].intVal);}
               else if (strcmp(vars[pozitie].type, "bool") == 0) { return createBoolExpr(vars[pozitie].boolVal);}
               else if (strcmp(vars[pozitie].type, "char") == 0) { return createCharExpr(vars[pozitie].charVal);}
               else if (strcmp(vars[pozitie].type, "float") == 0) { return createFloatExpr(vars[pozitie].floatVal);}
          }
     }
     else { //daca val este elementul unui vector
          char * temp, * numar;
          int index;
          temp = strtok(val, "[");
          pozitie = existsVar(temp);
          if (pozitie != -1){ //este o variabila
          numar = strtok(NULL, "]");
          index = atoi(numar);
               if (vars[pozitie].isInit == true){
                    if (strcmp(vars[pozitie].type, "intArray") == 0) { return createIntExpr(vars[pozitie].intArrayVal[index]);}
                    else if (strcmp(vars[pozitie].type, "boolArray") == 0) { return createBoolExpr(vars[pozitie].boolArrayVal[index]);}
                    else if (strcmp(vars[pozitie].type, "string") == 0) { return createCharExpr(vars[pozitie].strVal[index]);}
                    else if (strcmp(vars[pozitie].type, "floatArray") == 0) { return createFloatExpr(vars[pozitie].floatArrayVal[index]);}
               }
          }
     }
     return createInvalidExpr();
}
Expr* createInvalidExpr(){
     Expr* expr = (Expr*)malloc(sizeof(Expr));
     strcpy(expr->type, "invalid");
     return expr;
}
Expr* createIntExpr(int val){
     Expr* expr = (Expr*)malloc(sizeof(Expr));
     expr->intVal = val;
     strcpy(expr->type, "int");
     return expr;
}
Expr* createBoolExpr(bool val){
     Expr* expr = (Expr*)malloc(sizeof(Expr));
     expr->boolVal = val;
     strcpy(expr->type, "bool");
     return expr;
}
Expr* createFloatExpr(float val){
     Expr* expr = (Expr*)malloc(sizeof(Expr));
     expr->floatVal = val;
     strcpy(expr->type, "float");
     return expr;
}
Expr* createCharExpr(char val){
     Expr* expr = (Expr*)malloc(sizeof(Expr));
     expr->charVal = val;
     strcpy(expr->type, "char");
     return expr;
}


void yyerror(char * s){
  printf("Eroare, %s la linia:%d\n",s,yylineno);
}

int main(int argc, char** argv){
  yyin=fopen(argv[1],"r");
  yyparse();
  FILE * functionsFile = fopen ("symbol_table_functions.txt", "w");
  FILE * othersFile = fopen ("symbol_table.txt", "w");
  printFunctions(functionsFile);
  printStructures(othersFile);
  printVars(othersFile);
} 
