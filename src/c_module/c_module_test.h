#include <cxxtest/TestSuite.h>

extern "C" {
#include <c_module/c_module.h>
}

class CModule_test : public CxxTest::TestSuite
{
public:

	void test_dummy(){
		c_module_function();
		TS_ASSERT(true);
	}

};
