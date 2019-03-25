# Documentation

## Contributors
The following code was made by Jay Ramirez, A01365369 and Diego A. Ramirez, A01364225
based on the code created for the class of computer languages from the 7th semester.
Unlike the previous program, this program not only scans a language file, it also
dumps the content of the variables into a symbol table with the following data, indexed
by the key:
- Variable name
- Line it was found at
- Scope depth
- Type (Integer, real number)

## Building
To build the program, one has to run the following command on Linux:
make tinyc
Ex.
user:/home/Stg1_Parser$ make tinycgrammar

There will be some warnings related to lex and bison, but they can be safely ignore, for now 
at least.

## Running
To test the program one must do the following:
1. In the console in the current directory run: ./TinyC < fname
    where fname is a file with \n newline ending and any extension
    since we don't enforce file extension checking yet.

## Erasing
To delete the objects generated by the parser compilation one must 
run this command
make delete
Ex.
user:/home/Stg1_Parser$ make delete

## Notices
We include three test files to make easier the evaluation of the parser.

### Behavior on error
The parser will stop parsing once it finds an error.

### Known bugs
The following expression
i := i + 1;
won´t work unless there is a space between the plus sign or less sign in case of negative numbers.
The program won't work with CRLF end lined files, just with LF ended files.