module dunit.testreport;

import dunit.testresult;

import core.time;
import std.string;
import std.stdio;

class TestReport {
private:
    static void printContent(Throwable[string] results, in string content) {
        // print a blank line
        writeln("");
        size_t sum = results.length;
        string pre = "There " ~ (sum == 1 ? "was " : "were ");
        string post = " " ~ content  ~ (sum == 1 ? "" : "s" ~ ":");

        writeln(pre, sum, post);
        uint num = 0;

        foreach (name, exception; results) {
            writeln(++num, ") ", name);
            string msg = exception.toString();
            ptrdiff_t index = indexOf(msg, '-');

            // print content of the exception
            writeln(msg[0..index-1]);
        }
        writeln("------------------------------------------------------------");
    }
public:
    static void print(TestResult[] results) {
        Duration elapsedTime;
        Throwable[string] errors;
        Throwable[string] failures;
        string resultStr;
        uint sum = 0;

        foreach (result; results) {
            foreach (str, e; result.getErrors()) {
                errors[str] = e;
            }
            foreach (str, e; result.getFailures()) {
                failures[str] = e;
            }
            sum += result.getSum();
            elapsedTime += result.getTime();
            resultStr ~= result.getSign();
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

