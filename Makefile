# ------------------------------------------------------------------------------
#  Configuration options
# ------------------------------------------------------------------------------

CXX := 				g++
CXXFLAGS :=			-Wall -O2

CC := 				gcc
CFLAGS :=			-Wall -O2

LDFLAGS :=			

# ------------------------------------------------------------------------------
#  Target specification
# ------------------------------------------------------------------------------

all : 				build/c_demo \
				build/cpp_demo

build/c_demo : 	build/c_module/c_module.o \
				build/c_demo_prgm/main.o
	$(LINKCC)

build/cpp_demo : 	build/c_module/c_module.o \
				build/cpp_module/cpp_module.o \
				build/cpp_demo_prgm/main.o
	$(LINKCXX)

# ------------------------------------------------------------------------------
#  Test specification
# ------------------------------------------------------------------------------

build/tests/c_module/c_module_unit : build/c_module/c_module.o
build/tests/c_module/c_module_unit : LINKWITH := build/c_module/c_module.o

build/tests/cpp_module/cpp_module_unit : build/cpp_module/cpp_module.o
build/tests/cpp_module/cpp_module_unit : LINKWITH := build/cpp_module/cpp_module.o

# ------------------------------------------------------------------------------
#  General targets
# ------------------------------------------------------------------------------

tests : $(shell find src -name *_test.h | sed -e 's/_test.h/_unit/g;s/src/build\/tests/g')
docs :	
	doxygen src/docs/Doxyfile
clean :
	rm -rf build

.PHONY : clean all tests docs

# -----------------------------------------------------------------------------
#  Implicit rules
# -----------------------------------------------------------------------------

CFLAGS += 	-Isrc
LINKCC = 	gcc $^ $(LDFLAGS) -o $@
LINKCXX = 	g++ $^ $(LDFLAGS) -o $@

build/%.o : src/%.cpp src/%.h Makefile
	@mkdir -pv $(dir $@)
	$(CXX) $(CFLAGS) -c $< -o $@

build/%.o : src/%.cpp Makefile
	@mkdir -pv $(dir $@)
	$(CXX) $(CFLAGS) -c $< -o $@

build/%.o : src/%.c src/%.h Makefile
	@mkdir -pv $(dir $@)
	$(CC) $(CFLAGS) -c $< -o $@

build/%.o : src/%.c Makefile
	@mkdir -pv $(dir $@)
	$(CC) $(CFLAGS) -c $< -o $@

build/tests/%_unit : src/%_test.h Makefile
	@mkdir -pv $(dir $@)
	cxxtest/bin/cxxtestgen --error-printer -o \
	build/tests/$*_runner.cpp \
	$<
	$(CXX) -Wall -Icxxtest -Isrc $(INCLUDES) -c build/tests/$*_runner.cpp \
	-o build/tests/$*_runner.o
	$(CXX) $(LINKWITH) $(LIBS) build/tests/$*_runner.o -o $@
