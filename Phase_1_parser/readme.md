# Documentation

##Contributors
The following code was made by Jay Ramirez, A01365369 and Diego A. Ramirez, A01364225
based on the code for the lexer created by Diego, Alias Halo.

##Building
To build the program, one has to run the following command on Linux:
make tinycgrammar
Ex.
user:/home/Phase_1_parser$ make tinycgrammar

##Running
To test the program one must do the following:
1. In the console in the current directory run: ./TinyC < fname
    where fname is a file with \n newline ending and any extension
    since we don't enforce file extension checking

##Erasing
To delete the objects generated by the parser compilation one must 
run this command
make delete
Ex.
user:/home/Phase_1_parser$ make delete

##Notices
We include the four tests provided by Schoology to make easier the evaluation of the parser.

###Behavior on error
The parser will stop consuming tokens once it detects an error in the formation of the grammar.

###Known bugs
The following expression
i := i + 1;
won´t work unless there is a space between the plus sign or less sign in case of negative numbers.
The program won't work with CRLF end lined files, just with LF.

###Other considerations
To make easier the debugging process, the program writes at console the token type it is currently
consuming, but not the line number because we are this primitive.