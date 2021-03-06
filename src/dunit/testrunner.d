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
            XmlReport report = new XmlReport(reports["xml"], suite);

            report.print();
        }
        if (reports["csv"] !is null) {
            CsvReport report = new CsvReport(reports["csv"], suite);

            report.print();
        }
        if (reports["html"] !is null) {
            HtmlReport report = new HtmlReport(reports["html"], suite);

            report.print();
        }
        TestReport report = new TestReport(suite);

        report.print();
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

