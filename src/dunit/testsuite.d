module dunit.testsuite;

import dunit.test;
import dunit.testcase;
import dunit.testresult;

debug {
    import std.stdio;
}

class TestSuite : Test {
private:
    Test[] tests;
    string name;
public:
    this(string name = null) {
        this.name = name;
    }

    Test[] getTests() {
        return tests;
    }
    final override TestResult getResult() {
        return null;
    }
    string getName() {
        return name;
    }

    void addTest(TestSuite suite) {
        if (this == suite) {
            return;
        }
        foreach (test; tests) {
            if (test == suite) {
                return;
            }
        }
        tests ~= suite;
    }

    void addTestSuite(T : TestCase)() {
        foreach (test; tests) {
            if (test.getResult().getClass().name == typeid(T).name) {
                return;
            }
        }
        T test = new T();

        test.run!T();
        tests ~= test;
    }
}

