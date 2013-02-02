#include <cstdio>
#include <iostream>
#include <cpp_module/cpp_module.h>
extern "C" {
#include <c_module/c_module.h>
}

int main(int argc, char **argv)
{
  cpp_module_function();
  c_module_function();
 
  return EXIT_SUCCESS;
}
