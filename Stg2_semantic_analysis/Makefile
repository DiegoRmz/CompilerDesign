###########################################################################
#
# File name:    Makefile
#
# Description:  Makefile for the Bison output
#
# History:
#
#          Wed Oct 3 09:07 2018-- file is created
#
###########################################################################

#Toolchain to use
GCC 	= gcc
LEX		= flex
YACC	= bison

# Compiler flags
FFLAG 	=`pkg-config --cflags --libs glib-2.0` -lfl -Wall -O2 -pedantic

# Filenames
TGT_NAME = TinyC
LEXPARAM = scanner.l
BISPARAM = parser.y
SRC = parser.tab.c

#Rule definition
tinyc: 
	$(LEX) $(LEXPARAM)
	$(YACC) -v $(BISPARAM)
	$(GCC) $(SRC) -o $(TGT_NAME) $(FFLAG)

#To delete all the things
delete:
	rm -f $(SRC)
	rm -f $(TGT_NAME)
	rm -f lex.yy.c
	rm -f parser.tab.c
	rm -f parser.output