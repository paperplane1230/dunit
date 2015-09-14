module dunit.testrunner;

import dunit.test;
import dunit.testsuite;
import dunit.testcase;
import dunit.testresult;
import dunit.testreport;

import std.getopt;
import std.stdio;

class TestRunner {
private:
    static void print(string[string] reports, TestSuite suite) {
        Test[] tests = suite.getTests();

        if (reports["xml"] !is null) {
            XmlReport report = new XmlReport(reports["xml"], suite.getName());

            report.print(tests);
        }
        if (reports["csv"] !is null) {
            /* CsvReport.print(results, reports["csv"]); */
        }
        if (reports["html"] !is null) {
            /* HtmlReport.print(results, reports["html"]); */
        }
        TestReport report = new TestReport();

        report.print(tests);
    }

    static string[string] dowithParameters(string[] args) {
        GetoptResult result;
        string[string] reports;

        reports["xml"] = null;
        reports["csv"] = null;
        reports["html"] = null;

        try {
            result = getopt(args,
                    "xml", "Write XML test report", &reports["xml"],
                    "csv", "Write CSV test report", &reports["csv"],
                    "html", "Write HTML test report",
                        &reports["html"]);
        } catch (Exception exception) {
            stderr.writeln("error: ", exception.msg);
            return null;
        }
        if (result.helpWanted) {
            defaultGetoptPrinter("Options:", result.options);
            return null;
        }
        return reports;
    }
public:
    static void run(TestSuite suite, string[] args = null) {
        string[string] reports = dowithParameters(args);

        if (reports is null) {
            return;
        }
        print(reports, suite);
    }

    static void run(T : TestCase)(string[] args = null) {
        string[string] reports = dowithParameters(args);

        if (reports is null) {
            return;
        }
        TestSuite suite = new TestSuite();

        suite.addTestSuite!T();
        print(reports, suite);
    }
}

