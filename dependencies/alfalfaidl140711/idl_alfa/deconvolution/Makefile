# $ID: cleantools v1.0.3 (2009/06/09) Exp $
CC = gcc

CFLAGS= -g -O2 -c -O3 -fPIC -m64 -D_REENTRANT  -I/usr/local/itt/idl/external/include
LDFLAGS= -shared -lm 
SRCS=build_beam.c alfa_clean.c lib_version.c
OBJS=build_beam.o alfa_clean.o lib_version.o

all: clean_tools.so

$(SRCS):
	$(CC) $(CFLAGS) -c $*.c

clean_tools.so: $(OBJS)
	$(CC) $(LDFLAGS) -o $@ $(OBJS)

# Test
.PHONY : test
test:
	idl -e '@clean_test.batch' || exit $$?;

# Clean up
.PHONY : clean
clean:
	-rm -f clean_tools.so *.o
