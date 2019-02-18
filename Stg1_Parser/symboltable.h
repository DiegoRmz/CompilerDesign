/**
 * Copyright (c) 2019 Diego A. Rmz
 *
 * @file    Parser.h
 *
 * @author  Diego A. Rmz
 *
 * @date    09 Feb 2019 16:27 DST
 *
 * @brief   Declares all the data structures to be used by the parse table.
 *
 * References:
 *          Code is based on previous code for linked lists from Advanced Programming
 *          and different internet references, like Professor Abelardo's code.
 *          Specifically, this file is based in the "Hash" example by Professor Abelardo.
 * 
 * Revision history:
 *          09 Feb 2019 16:27 DST -- File created
 */

#include <glib.h>

#define BUFFER_S 512 //Just in case 

//This enum came from professor Abelardo, and it is to define
//the types tiny c can handle
enum tinyCTypes {error = EXIT_FAILURE, integer, real, undefined};

/**
 * @union val
 *
 * @brief Defines the value of a symbol table element, since 
 * it is an union, it can be interpreted as a float, or as
 * an integer
 *
 */
union val {            
   int     integerVal;                   
   float   realVal;
   float   provisionalVal;
};

/**
 * @struct tableEntry
 *
 * @brief This is the "payload" that the hashtable carries,
 * and it serves to define a symbol obtained by the parser.
 * 
 * @c variableName The string holding the name of the variable, it may be
 *    different from the name of the entry or not.
 * 
 * @c type the variable is an int or a float?
 * 
 * @c scope Depth of the scope it was found {{{}}}
 * 
 * @c lineFoundAt # of line the variable was found at.
 */
typedef struct tableEntry_{
    char * variableName;    //Name for the variable found
    enum tinyCTypes type;   //Type for the variable
    int scope;              //Depth of scope the variable was found at {{}}
    int lineFoundAt;        //Line this variable was found at
    union val value;        //Value of the variable
}tableEntry;


typedef struct tableEntry_ *entry_p; /* Declaration of a pointer to the value of the table entry */

void printItem(gpointer key, gpointer value, gpointer user_data);
void printTable(GHashTable *hashTable);

entry_p newTableEntry(char *variableName, int scope, int lineFoundAt, union val value, enum tinyCTypes type);

gboolean offerEntryAtTable(entry_p theEntry, GHashTable *theTable);