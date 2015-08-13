module example.test2.testsuite2;

import dunit.testsuite;
import example.test2.testcase2;

class TestSuite2 {
public:
    static void TestSuite suite() {
        TestSuite suite = new TestSuite();

        suite.addTestSuite(testcase2.classinfo);
        return suite;
    }
}

