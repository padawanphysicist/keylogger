// #include <libguile.h>
#include <stdio.h>
#include <fcntl.h> 
#include <linux/input.h>
#include <unistd.h>

int
get_type (void* data)
{
  struct input_event* ev = (struct input_event*)data;
  return ev->type;
}

int
get_code (void* data)
{
  struct input_event* ev = (struct input_event*)data;
  return ev->code;
}

int
get_value (void* data)
{
  struct input_event* ev = (struct input_event*)data;
  return ev->value;
}
/* int */
/* read_event (int fd) */
/* { */
/*   printf("reading from file descriptor:%d\n", fd); */
/*   struct input_event ev; */
/*   ssize_t n = read (fd, &ev, sizeof (ev)); */
/*   printf("aaaabbbbccc\n"); */
/*   if (ev.type == EV_KEY && ev.value == 1)  */
/*   { */
/* 	  printf("hahaha"); */
/*   	} */
/*   return ev.value; */
/* } */

/* int main (void) */
/* { */
/*   // The buffer path */
/*   const char *dev = "/dev/input/by-path/platform-i8042-serio-0-event-kbd"; */
/*   int fd; */
/*   fd = open(dev, O_RDONLY); // Open the buffer */
/*   if (fd == -1) return EXIT_FAILURE; */
 
/*   struct input_event ev; */
/*   ssize_t n; */
 
/*   // Our keylogger need to read every keystroke, so we will need to loop until break */
/*   while (1) { */
/*     n = read(fd, &ev, sizeof ev); // Read from the buffer */
 
/*     /\* Now, if everything went as expected and a key is */
/*      *   pressed we should have an event, events looks like this: */
/*      * */
/*      * struct input_event { */
/*      * struct timeval time; */
/*      * unsigned short type; // Type of event, we are looking for EV_KEY */
/*      * unsigned short code; // Key code in LKC standard (See bellow) */
/*      * unsigned int value; // 0 == released; 1 == pressed; 2 == repeated */
/*      * }; */
/*      *\/ */
 
/*     // Now that we have an event, we have to filter it to just */
/*     // fire when the event is EV_KEY and a key is pressed down */
/*     if (ev.type == EV_KEY && ev.value == 1)) */
/*     printf("Key %d has been pressed\n", ev.code); */
 
/*     // Since we want a safe way to kill the loop safely (closing the stream and all) */
/*     if (ev.value == KEY_ESC) break; */
/*     // As you see, we can use key defs from input-event-codes.h */
/* } */
/* // And don't forget to close the buffer and exit safely */
/* close(fd); */
/* fflush(stdout); */
/* return EXIT_FAILURE; */
/* } */
