module dunit.testsuite;

import dunit.testcase;

import std.algorithm;

class TestSuite {
private:
    TypeInfo_Class[] tests;
public:
    TypeInfo_Class[] getTests() {
        return tests;
    }

    void addTest(TestSuite suite) {
        foreach (testcase; suite.getTests()) {
            if (find(tests, testClass).length == 0) {
                tests ~= testcase;
            }
        }
    }

    void addTestSuite(TypeInfo_Class testClass) {
        TypeInfo_Class type = testClass;
        bool isTestCase = false;

        while (type !is null) {
            if (type == TestCase.classinfo) {
                isTestCase = true;
                break;
            }
            type = type.base;
        }
        if (!isTestCase) {
            throw new Exception("The parameter of addTestSuite must be a class"
                            "derived from TestCase.");
        }
        if (find(tests, testClass).length == 0) {
            tests ~= testClass;
        }
    }
}

