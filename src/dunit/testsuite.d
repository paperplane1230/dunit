module dunit.testsuite;

import dunit.testcase;
import dunit.testresult;

debug {
    import std.stdio;
}

class TestSuite {
private:
    TestResult[] results;
    string name;
public:
    this(string name = null) {
        this.name = name;
    }
    TestResult[] getResults() {
        return results;
    }

    void addTest(TestSuite suite) {
        foreach (result; suite.getResults()) {
            foreach (thisResult; results) {
                if (result.getClass().name == thisResult.getClass().name) {
                    continue;
                }
            }
            results ~= result;
        }
    }

    void addTestSuite(T : TestCase)() {
        foreach (result; results) {
            if (result.getClass().name == typeid(T).name) {
                return;
            }
        }
        results ~= TestCase.run!T(name);
    }
}

