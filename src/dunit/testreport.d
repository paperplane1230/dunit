module dunit.testreport;

import dunit.testresult;

import core.time;
import std.string;

class TestReport {
private:
    uint printContent(in Exception[string] results, in string content) {
        // print a blank line
        writeln("");
        size_t sum = results.length;
        string pre = "There " ~ sum == 1 ? "was " : "were ";
        string post = " " ~ content  ~ sum == 1 ? "" : "s" ~ ":";

        writeln(pre, sum, post);
        uint num = 0;

        foreach (name, exception; results) {
            writeln(++num, ") ", name);
            string msg = exception.toString();
            int index = indexOf(msg, '-');

            // print content of the exception
            writeln(msg[0..index]);
        }
        writeln("----------------------------------------------");
    }
public:
    static void print(TestResult[] results, Duration elapsedTime) {
        Exception[string] errors;
        Exception[string] failures;
        uint sum = 0;
        uint errorSum = 0;
        uint failureSum = 0;

        foreach (result; results) {
            errors ~= result.getErrors();
            failures ~= result.getFailures();
            sum += result.getSum();
        }
        if (errors.length != 0) {
            errorSum = printContent(errors, "error");
        }
        if (failures.length != 0) {
            errorSum = printContent(failures, "failure");
        }
        writeln("");
        writefln("Tests run: %d, failures: %d, errors: %d.",
                sum, failureSum, errorSum);
        writeln("Time: ", elapsedTime);
        string res = errorSum == 0 && failureSum == 0 ? "Ok!" : "Not ok!";

        writeln(res);
    }
}

