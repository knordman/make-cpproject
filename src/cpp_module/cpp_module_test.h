#include <cxxtest/TestSuite.h>
#include <cpp_module/cpp_module.h>

class CppModule_test : public CxxTest::TestSuite
{
public:

	void test_dummy(){
		cpp_module_function();
		TS_ASSERT(true);
	}

};
