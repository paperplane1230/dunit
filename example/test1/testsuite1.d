module example.test1.testsuite1;

import example.test1.testcase1;
import dunit.testsuite;

class TestSuite1 {
public:
    static void TestSuite suite() {
        TestSuite suite = new TestSuite();

        suite.addTestSuite(testcase1.classinfo);
        return suite;
    }
}

