GUILE_CFLAGS=`pkg-config --cflags --libs guile-3.0`

klogger.o: klogger.c
	gcc -c klogger.c -o klogger.o `pkg-config --cflags guile-3.0`
klogger.so: klogger.o
	gcc -Wall -Werror -shared -fPIC $(GUILE_CFLAGS) klogger.o -o klogger.so

run: keylogger.scm klogger.so
	sudo $$LD_LIBRARY_PATH=./ guile -s keylogger.scm
