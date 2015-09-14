module dunit.testsuite;

import dunit.test;
import dunit.testcase;
import dunit.testresult;

import core.time;

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
            if (test.getResult().getClass() == typeid(T).name) {
                return;
            }
        }
        T test = new T();

        test.run!T();
        tests ~= test;
    }
    Duration getTime() {
        Duration time;

        foreach (test; tests) {
            TestResult result = test.getResult();

            if (result !is null) {
                // it's a testcase
                time += result.getTotalTime();
            } else {
                // its' a testsuite
                time += (cast(TestSuite)test).getTime();
            }
        }
        return time;
    }
}

