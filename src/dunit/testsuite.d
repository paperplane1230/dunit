module dunit.testsuite;

import dunit.testcase;

import core.thread;

class TestSuite : Thread {
private:
    TestCase[] tests;

    void run() {

    }
public:
    this() {
        super(&run);
    }
    void addTest(TestSuite suite) {

    }
    void addTestSuite(TypeInfo_Class testClass) {
        
    }
}

