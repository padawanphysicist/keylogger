CC=gcc
CFLAGS=-Wall -Werror
GUILE_CFLAGS=`pkg-config --cflags guile-3.0`
GUILE_CLIBS=`pkg-config --libs guile-3.0`

.PHONY: all clean

all: input.so

input.o: input.c
	$(CC) $(CFLAGS) $(GUILE_CFLAGS) -c $< -o $@
input.so: input.o
	$(CC) $(CFLAGS) -shared -fPIC $(GUILE_CLIBS) $<  -o $@

clean:
	rm *.o *.so
