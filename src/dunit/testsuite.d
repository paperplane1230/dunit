module dunit.testsuite;

import dunit.testcase;
import dunit.testresult;

class TestSuite {
private:
    TestResult[] results;
public:
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
        T test = new T();

        foreach (result; results) {
            if (result.getClass().name == typeid(test)) {
                return;
            }
        }
        test.run();
        results ~= test.getResult();
    }
}

