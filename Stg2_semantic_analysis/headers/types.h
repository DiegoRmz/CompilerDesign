#ifndef TYPES_H
#define TYPES_H

#include "symboltable.h"

int variableDefOk(tableEntryNPtr **ss, char * identifier);
int definitionTypesOk(tableEntryNPtr **ss, char * identifier, char * typeTranslateable);
int checkMathematicalOperations(tableEntryNPtr **ss, entry_p s1, entry_p s2);
int checkRelationalOperations(tableEntryNPtr **ss, entry_p s1, entry_p s2);
int checkTypesOfAssignment(tableEntryNPtr **ss, entry_p s1, entry_p s2);
enum tinyCTypes translateStringType(char * type);

#endif