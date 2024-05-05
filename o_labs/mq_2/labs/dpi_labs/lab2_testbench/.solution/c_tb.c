// Example of SystemVerilog calling a C task, which calls back into SV tasks
// For Lab 2 of Mastering Questa DPI chapter

#include "dpiheader.h"
#include <stdio.h>

extern void sv_mem_allocate(int);
extern int sv_mem_write(int, int);

//LAB: Add a third arg of type int to the sv_mem_read() declaration
extern int sv_mem_read(int, int*, int);
extern int sv_time();


int c_testbench(const char* fname) {
  char cmd;
  FILE *file;

  printf("C : c_testbench '%s'\n", fname);

  file = fopen(fname, "r");
  while (!feof(file)) {
    cmd = fgetc(file);
    switch (cmd) {

    case 'M': { // Memory allocate
      int size;
      fscanf(file, "%d", &size);
      printf("C  @%d: M %d\n", sv_time(), size);
      sv_mem_allocate(size);
      break;
    } // 'M'


    case 'W': { // Memory write
      int addr, data;
      fscanf(file, "%d%d", &addr, &data);
      printf("C  @%d: W %d %d\n", sv_time(), addr, data);
      sv_mem_write(addr, data);
      break;
    } // 'W'


    case 'R': { // Memory read with expect
      int addr, exp, data;
      fscanf(file, "%d%d", &addr, &exp);
      printf("C  @%d: R %d %d\n", sv_time(), addr, exp);

      //LAB: Pass the expected value as the third argument
      sv_mem_read(addr, &data, exp);

      //LAB: Move this entire check to sv_mem_read() and delete here
      //      if (data != exp)
      //	printf("C  @%d: Error: Data=%d, expected=%d\n", sv_time(), data, exp);

      break;
    } // 'R'

    case '#': { // Comment - echo it
      char bucket[256];
      fscanf(file, "%255[^\n]\n", &bucket);
      printf("C  @%d: #%s", sv_time(), bucket);
      break;
    } // '#'

    case '\n': { // Line break
      printf("\n");
      break;
    } // '#'

    } // switch
  } // while

  fclose(file);
  return 0; // No disable
} // c_testbench
