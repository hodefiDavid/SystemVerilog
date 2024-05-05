/*****************************************************************************
 Routine to read a file and print the value
 The file has:
  M 100

For the Mastering Questa learning path, Creating and Debugging DPI
chapter, lab 1, file read.

*****************************************************************************/

//LAB: Include dpiheader.h
#include "dpiheader.h"
#include <stdio.h>

//LAB: Delete the main routine
/*
int main(int argc, char* argv[]) {
  printf("%s: Opening '%s'\n", argv[0], argv[1]);
  printf("%s: size=%d\n", argv[0], c_fmread(argv[1]));
  return 0;
}
*/

int c_fmread(const char* fname) {
  int size;
  FILE *file;

  file = fopen(fname, "r");
  if (file==NULL) {
    perror("Failed: ");
    return -1;
  }

  fscanf(file, "M %d", &size);
  fclose(file);
  return size;
}
