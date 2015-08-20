module dunit.testrunner;

import dunit.testsuite;

class TestRunner {
public:
    static void run(TestSuite suite, string args = null) {
        foreach (testcase; suite.getTests()) {
            testcase.start();
        }
    }
}

