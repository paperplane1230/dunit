module dunit.testreport;

import dunit.test;
import dunit.testresult;
import dunit.testsuite;

import core.time;
import std.string;
import std.stdio;

class Report {
private:
    Throwable exception;
    string name;
public:
    this(string n, Throwable e) {
        exception = e;
        name = n;
    }

    Throwable getThrowable() {
        return exception;
    }
    string getName() {
        return name;
    }
}

class TestReport {
private:
    static void printContent(Report[] results, string content) {
        // print a blank line
        writeln("");
        size_t sum = results.length;
        string pre = "There " ~ (sum == 1 ? "was " : "were ");
        string post = " " ~ content  ~ (sum == 1 ? ":" : "s:");

        writeln(pre, sum, post);
        uint num = 0;

        foreach (result; results) {
            writeln(++num, ") ", result.getName());
            string msg = result.getThrowable().toString();
            ptrdiff_t index = indexOf(msg, '-');

            // print content of the exception
            writeln(msg[0..index-1]);
        }
        writeln("------------------------------------------------------------");
    }

    static void getResults(Test tests, ref Duration elapsedTime,
                ref Report[] errors, ref Report[] failures,
                ref string resultStr, ref ulong sum) {
        TestResult result = tests.getResult();

        if (result is null) {
            foreach (test; (cast(TestSuite)tests).getTests()) {
                getResults(test, elapsedTime, errors, failures,
                        resultStr, sum);
            }
            return;
        }
        foreach (str, e; result.getErrors()) {
            errors ~= new Report(str, e);
        }
        foreach (str, e; result.getFailures()) {
            failures ~= new Report(str, e);
        }
        sum += result.getSum();
        elapsedTime += result.getTotalTime();
        resultStr ~= result.getSign();
    }
public:
    static void print(Test[] tests) {
        Duration elapsedTime;
        Report[] errors;
        Report[] failures;
        string resultStr;
        ulong sum = 0;

        foreach (test; tests) {
            getResults(test, elapsedTime, errors, failures, resultStr, sum);
        }
        writeln(resultStr);
        if (errors.length != 0) {
            printContent(errors, "error");
        }
        if (failures.length != 0) {
            printContent(failures, "failure");
        }
        writeln("");
        writefln("Test(s) run: %d, failure(s): %d, error(s): %d.",
                sum, failures.length, errors.length);
        writeln("Time: ", elapsedTime, "\n");
        string res = (errors.length == 0 && failures.length == 0)
                    ? "Ok!!" : "Not ok!!";

        writeln(res);
    }
}

/* class XmlReport { */
/*     import std.xml; */
/* public: */
/*     static void print(TestResult[] results, string filename) { */
/*         Document document = new Document(new Tag("testsuite")); */
/*         string preName = results[0].getSuiteName(); */
/*         size_t index = 1; */

/*         if (preName !is null) { */
/*             document.tag.attr["name"] = preName; */
/*         } */
/*         foreach (result; results) { */
            
/*         } */
/*         Duration elapsedTime; */
/*         Throwable[string] errors; */
/*         Throwable[string] failures; */
/*         string resultStr; */
/*         uint sum = 0; */

/*         foreach (result; results) { */
/*             foreach (str, e; result.getErrors()) { */
/*                 errors[str] = e; */
/*             } */
/*             foreach (str, e; result.getFailures()) { */
/*                 failures[str] = e; */
/*             } */
/*             sum += result.getSum(); */
/*             elapsedTime += result.getTime(); */
/*             resultStr ~= result.getSign(); */
/*         } */
/*         writeln(resultStr); */
/*         if (errors.length != 0) { */
/*             printContent(errors, "error"); */
/*         } */
/*         if (failures.length != 0) { */
/*             printContent(failures, "failure"); */
/*         } */
/*         writeln(""); */
/*         writefln("Test(s) run: %d, failure(s): %d, error(s): %d.", */
/*                 sum, failures.length, errors.length); */
/*         writeln("Time: ", elapsedTime, "\n"); */
/*         string res = (errors.length == 0 && failures.length == 0) */
/*                     ? "Ok!!" : "Not ok!!"; */

/*         writeln(res); */
/*     } */
/* } */

