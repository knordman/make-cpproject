# make-cpproject

## Introduction

Buildsystems are usually feature-rich and complex, consider e.g.
Autotools or embedded buildchains included in IDE:s such as
Eclipse. One problem with these buildsystems is that a lot of extra
files are added to the project directory. The cluttered directory is
difficult to browse and has a "messy" feeling. Especially for small
projects, it is more tempting to use a handwritten Makefile. Without
care however, the handwritten file gets difficult to maintain and
lengthy. Furthermore, to ease browsability, a logical and clear
directory structure is important.

To meet these challenges, **make-cpproject** tries to provide a
template for small projects that:

- Has a short, understandable and maintainable Makefile
- Promotes a clear project directory structure

Besides structuring the project directory, **make-cpproject** sets up
unit tests using [CxxTest](http://cxxtest.com/).

*Tested using GNU make 3.81.*

## Cloning the template

Since the template sets up unit tests with
[CxxTest](http://cxxtest.com/), it is included as a submodule in the
repository. In order to get a complete template, the submodule has to
be initialized, i.e. after cloning

    git clone git://github.com/knordman/make-cpproject.git

do

    git submodule init
    git submodule update

## Usage

The provided Makefile is short and should not be difficult to
read. The main idea is to use the directory structure for specifying
buildable targets, instead of adding more lines to the
Makefile. Therefore the Makefile is mainly driven by general, implicit
rules. The basic usage philoshopy is explained below.

The project is assumed to produce one or more executable
programs. Each program is a combination of submodules. The source code
of each submodule is located in a unique directory inside the
top-level **src** directory.

All compiled object files and executables are placed in a top-level
**build** directory. This way the project folder does not get
cluttered, and a `make clean` can simply do its job by removing the
build directory.

### Target specification

A C program is defined by listing the objects it is made out of, and a
terminating "link" statement, e.g.:

    build/PROGRAM : build/MODULE-1/OBJECT-1.o \
                    build/MODULE-1/OBJECT-2.o
                    build/MODULE-2/OBJECT.o
        $(LINKCC)

Alternatively one should use `$(LINKCXX)` if the program is a C++
program. Each of the objects specified are then implicitly defined to
be built from a corresponding *src/module-name/object-name.c*. If it
exists, an object file is also assumed to be dependent on the header
file *src/module-name/object-name.h*. Specifying additional
dependencies, or changing compile parameters for a specific object,
can be done as:

    build/MODULE-1/OBJECT-1.o : ADDITIONAL-DEPENDENCIES
    build/MODULE-1/OBJECT-1.o : CFLAGS = ...

This unfortunately adds additional lines to the Makefile, but is
sometimes necessary.

### Unit test specification

Unit tests are written in *NAME_test.h* files. Running `make tests`
will find all such test defintions and try to compile them into
executable tests.

Say for example that a test has been written and saved in
*src/MODULE-1/simple_test.h*, and is a test for *MODULE-1*. The
executable test will then built to
*build/tests/MODULE-1/simple_unit*. Usually the executable test will
have to be linked with some object files (the ones being
tested). These objects have to be specified in the Makefile, using the
`LINKWITH` variable:

    build/tests/MODULE-1/simple_unit : LINKWITH = build/MODULE-1/object-tested.o

In the same way, the object file can be specified as an dependency to
the test:

    build/tests/MODULE-1/simple_unit : build/MODULE-1/object-tested.o

See the demo, for examples. If there are many object files that has to
be linked into the test, it is clearly beneficial to put these in a
variable of their own, to avoid having to write the object names
twice, once for `LINKWITH`, and once for adding dependencies.

### Including headers of modules in other modules

When modules are compiled, the top-level **src** directory is added to
the include path. This means that including a header file from a
module in a different module, or in a main file, can be done as:

    #include <MODULE-NAME/HEADER-NAME.h>

### Demo

A cloned template includes a demo for a C in addition to a C++
program.