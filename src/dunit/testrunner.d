module dunit.testrunner;

import dunit.testsuite;
import dunit.testcase;
import dunit.testresult;
import dunit.testreport;

import std.getopt;
import std.stdio;

class TestRunner {
private:
    static void print(string[string] reports, TestResult[] results) {
        bool print = true;

        if (reports["xml"] !is null) {
            /* XmlReport.print(results, reports["xml"]); */
            print = false;
        }
        if (reports["csv"] !is null) {
            /* CsvReport.print(results, reports["csv"]); */
            print = false;
        }
        if (reports["html"] !is null) {
            /* HtmlReport.print(results, reports["html"]); */
            print = false;
        }
        if (print) {
            TestReport.print(results);
        }
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

        if (reports == null) {
            return;
        }
        TestResult[] results;

        foreach (result; suite.getResults()) {
            results ~= result;
        }
        print(reports, results);
    }

    static void run(T : TestCase)(string[] args = null) {
        string[string] reports = dowithParameters(args);

        if (reports == null) {
            return;
        }
        T test = new T();

        test.run!T();
        TestResult[] results;

        results ~= test.getResult();
        print(reports, results);
    }
}

