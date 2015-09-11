module dunit.testrunner;

import dunit.testsuite;
import dunit.testcase;
import dunit.testresult;
import dunit.testreport;

class TestRunner {
public:
    static void run(TestSuite suite, string[] args = null) {
        TestResult[] results;

        foreach (result; suite.getResults()) {
            results ~= result;
        }
        TestReport.print(results);
    }

    static void run(T : TestCase)(string[] args = null) {
        T test = new T();

        test.run!T();
        TestResult[] results;

        results ~= test.getResult();
        TestReport.print(results);
    }
}

