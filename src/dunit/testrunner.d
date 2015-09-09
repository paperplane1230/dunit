module dunit.testrunner;

import dunit.testsuite;
import dunit.testcase;
import dunit.testresult;
import dunit.testreport;

import core.time;
import core.thread;

class TestRunner {
public:
    static void run(TestSuite suite, string[] args = null) {
        TestResult[] results;
        TickDuration startTime = TickDuration.currSystemTick();

        foreach (testcase; suite.getTests()) {
            auto test = cast(testcase)Object.factory(testcase.name);

            results ~= test.getResult();
        }
        Duration elapsedTime
                = cast(Duration)(TickDuration.currSystemTick() - startTime);

        TestReport.print(results, elapsedTime);
    }

    static void run(TypeInfo_Class tested, string[] args = null) {
        TestSuite suite = new TestSuite();

        suite.addTest(tested);
        run(suite, args);
    }
}

