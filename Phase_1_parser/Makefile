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
FFLAG 	= -lfl
ALLERR	= -Wall -pedantic
OPTIM   = -O2

# Filenames
LEXPARAM = Tinycj.l
TGT_NAME = TinyC
BISPARAM = TinyC.y

#Rule definition
tinycgrammar: 
	$(LEX) $(LEXPARAM)
	$(YACC) -v $(BISPARAM)
	$(GCC)  $(TGT_NAME).tab.c -o $(TGT_NAME) $(FFLAG) $(ALLERR) $(OPTIM)

#To delete all the things
delete:
	rm -f $(SRC)
	rm -f $(TGT_NAME)
	rm -f lex.yy.c
	rm -f TinyC.tab.c
	rm -f TinyC.output