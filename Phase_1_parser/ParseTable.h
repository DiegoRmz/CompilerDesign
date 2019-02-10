/**
 * Copyright (c) 2019 Diego A. Rmz
 *
 * @file    ParseTable.h
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
 *
 * Revision history:
 *          09 Feb 2019 16:27 DST -- File created
 */

#include <glib.h>

#define BUFFER_S 512 //Just in case 

//This enum came from professor Abelardo, and it is to define
//the types tiny c can handle
enum tinyCTypes {error = EXIT_FAILURE, integer, real};

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
};

/**
 * @struct item
 *
 * @brief This is the item that is to be stored at the hash table.
 *
 * It consists of a string to be the key of the item, and a pointer
 * to a data structure or whatever.
 */
typedef struct item_{
    char * key; 
    void * tableEntry; //Pointer to any data structure or type to be stored at the table
}item;

typedef struct item_ *item_p; //Pointer to the item type at the table

typedef struct tableEntry_{
    char * variableName;    //Name for the variable found
    enum tinyCTypes type;   //Type for the variable
    int scope;              //Depth of scope the variable was found at {{}}
    int lineFoundAt;        //Line this variable was found at
    union val value;        //Value of the variable
}tableEntry;


typedef struct tableEntry_ *entry_p; /* Declaration of a pointer to the value of the table entry */