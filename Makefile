# ------------------------------------------------------------------------------
#  Configuration options
# ------------------------------------------------------------------------------

CXX := 				g++
CXXFLAGS :=			-Wall -O2

CC := 				gcc
CFLAGS :=			-Wall -O2

LDFLAGS :=			

OUTPUT := 			build
SRC :=				src

# ------------------------------------------------------------------------------
#  Target specification
# ------------------------------------------------------------------------------

all : $(OUTPUT)/c_demo $(OUTPUT)/cpp_demo

$(OUTPUT)/c_demo :	$(OUTPUT)/c_module/c_module.o \
					$(OUTPUT)/c_demo_prgm/main.o
	$(LINKCC)

$(OUTPUT)/cpp_demo :	$(OUTPUT)/c_module/c_module.o \
					$(OUTPUT)/cpp_module/cpp_module.o \
					$(OUTPUT)/cpp_demo_prgm/main.o
	$(LINKCXX)


tests : $(shell find $(SRC) -name *_test.h | sed -e 's/_test.h/_unit/g;s/$(SRC)/$(OUTPUT)/g')
docs :	
	doxygen $(SRC)/docs/Doxyfile
clean :
	rm -rf build

.PHONY : clean all tests docs

# -----------------------------------------------------------------------------
# Implicit rules
# -----------------------------------------------------------------------------

CFLAGS += 			-Isrc
LINKCC := 			gcc $^ $(LDFLAGS) -o $@
LINKCXX := 			g++ $^ $(LDFLAGS) -o $@

$(OUTPUT)/%.o : $(SRC)/%.cpp $(SRC)/%.h Makefile
	@mkdir -pv $(dir $@)
	$(CXX) $(CFLAGS) -c $< -o $@

$(OUTPUT)/%.o : $(SRC)/%.cpp Makefile
	@mkdir -pv $(dir $@)
	$(CXX) $(CFLAGS) -c $< -o $@

$(OUTPUT)/%.o : $(SRC)/%.c $(SRC)/%.h Makefile
	@mkdir -pv $(dir $@)
	$(CC) $(CFLAGS) -c $< -o $@

$(OUTPUT)/%.o : $(SRC)/%.c Makefile
	@mkdir -pv $(dir $@)
	$(CC) $(CFLAGS) -c $< -o $@

$(OUTPUT)/%_unit : $(SRC)/%_test.h Makefile
	@mkdir -pv build/tests
	cxxtest/bin/cxxtestgen --error-printer -o build/tests/$*_runner.cpp $<
	$(CXX) -Wall \
		-I$(INCLUDES) \
		-Icxxtest -I. \
		-c build/tests/$*_runner.cpp \
		-o build/tests/$*_runner.o
	$(CXX) $(OBJECTS) $(LIBS) build/tests/$*_runner.o -o $@
