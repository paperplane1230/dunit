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
    TestSuite suite;
    Report[] errors;
    Report[] failures;

    string resultStr;
    ulong sum = 0;

    void printContent(Report[] results, string content) {
        // print a blank line
        writeln("");
        size_t length = results.length;
        string pre = "There " ~ (length == 1 ? "was " : "were ");
        string post = " " ~ content  ~ (length == 1 ? ":" : "s:");

        writeln(pre, length, post);
        uint num = 0;

        foreach (result; results) {
            writeln(++num, ") ", result.getName());
            string msg = result.getThrowable().toString();
            ptrdiff_t index = content == "error"
                            ? msg.length + 1 : indexOf(msg, '-');

            // print content of the exception
            writeln(msg[0..index-1]);
        }
        writeln("------------------------------------------------------------");
    }

    void getResults(Test tests) {
        TestResult result = tests.getResult();

        if (result is null) {
            foreach (test; (cast(TestSuite)tests).getTests()) {
                getResults(test);
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
        resultStr ~= result.getSign();
    }
public:
    this(TestSuite suite) {
        this.suite = suite;
    }

    void print() {
        foreach (test; suite.getTests()) {
            getResults(test);
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
        writeln("Time: ", suite.getTime(), "\n");
        string res = (errors.length == 0 && failures.length == 0)
                    ? "Ok!!" : "Not ok!!";

        writeln(res);
    }
}

class XmlReport {
    import std.xml;
private:
    Document document;
    TestSuite suite;
    string filename;

    void generate(Test[] tests, Element parent) {
        foreach (test; tests) {
            TestResult result = test.getResult();

            if (result !is null) {
                // not a testsuite
                foreach (name; result.getCases()) {
                    Element testcase = new Element("testcase");

                    testcase.tag.attr["time"] = "%.3f"
                            .format(result.getTime(name).total!"msecs" / 1000.0);
                    testcase.tag.attr["classname"] = result.getClass();
                    testcase.tag.attr["name"] = name;
                    if (result.getError(name) !is null) {
                        Throwable error = result.getError(name);
                        Element errorTag = new Element("error",
                                                    error.info.toString);
                        string errorMsg = error.toString();
                        size_t index = indexOf(errorMsg, '-');

                        errorTag.tag.attr["message"]
                            = "%s: %s".format(errorMsg[0..index-1], error.msg);
                        testcase ~= errorTag;
                    } else if (result.getFailure(name) !is null) {
                        Element failureTag = new Element("failure");
                        string failureMsg = result.getFailure(name).toString();
                        size_t index = indexOf(failureMsg, '-');

                        failureTag.tag.attr["message"] = failureMsg[0..index-1];
                        testcase ~= failureTag;
                    }
                    parent ~= testcase;
                }
            } else {
                // it's a testsuite
                Element testsuite = new Element("testsuite");
                string suiteName = (cast(TestSuite)test).getName();

                if (suiteName !is null) {
                    testsuite.tag.attr["name"] = suiteName;
                }
                generate((cast(TestSuite)test).getTests(), testsuite);
                parent ~= testsuite;
            }
        }
    }
public:
    this(string filename, TestSuite suite) {
        this.filename = filename;
        document = new Document(new Tag("testsuites"));
        this.suite = suite;
        if (suite.getName() !is null) {
            document.tag.attr["name"] = suite.getName();
        }
    }

    void print() {
        generate(suite.getTests(), document);
        import std.file;

        write(filename, document.toString());
    }
}

class CsvReport {
private:
    TestSuite suite;
    string context
        = "type,time,classname,name,failureMessage,errorMessage,errorContent\n";
    string filename;

    void generate(Test[] tests, ref string parent) {
        foreach (test; tests) {
            TestResult result = test.getResult();

            if (result !is null) {
                // not a testsuite
                foreach (name; result.getCases()) {
                    string testcase = "testcase,";

                    testcase ~= "%.3f,".format(
                            result.getTime(name).total!"msecs" / 1000.0);
                    testcase ~= "%s,".format(result.getClass);
                    testcase ~= "%s,".format(name);
                    if (result.getFailure(name) !is null) {
                        string failureMsg = result.getFailure(name).toString();
                        size_t index = indexOf(failureMsg, '-');

                        testcase ~= "\"%s\",".format(failureMsg[0..index-1]);
                    } else {
                        testcase ~= ",";
                    }
                    if (result.getError(name) !is null) {
                        Throwable error = result.getError(name);
                        string errorMsg = error.toString();
                        size_t index = indexOf(errorMsg, '-');

                        testcase ~= "\"%s:%s\",".format(errorMsg[0..index-1],
                                                error.msg);
                        testcase ~= "\"%s\"\n".format(
                                error.info.toString.replace("\n", ";"));
                    } else {
                        testcase ~= ",\"\"\n";
                    }
                    parent ~= testcase;
                }
            } else {
                // it's a testsuite
                string testsuite = "testsuite,";
                string suiteName = (cast(TestSuite)test).getName();

                if (suiteName !is null) {
                    testsuite ~= "%s,".format("%.3f"
                            .format((cast(TestSuite)test).getTime()
                                                .total!"msecs" / 1000.0));
                } else {
                    testsuite ~= ",";
                }
                testsuite ~= ",";
                testsuite ~= "%s,".format(suiteName);
                testsuite ~= ",,";
                testsuite ~= "\"\"\n";
                generate((cast(TestSuite)test).getTests(), testsuite);
                parent ~= testsuite;
            }
        }
    }
public:
    this(string filename, TestSuite suite) {
        this.filename = filename;
        this.suite = suite;
        string context;

        if (suite.getName() !is null) {
            context = "testsuite,%s,,%s,,,\"\"\n"
                .format("%.3f".format(suite.getTime().total!"msecs" / 1000.0),
                        suite.getName());
        } else {
            context = "testsuite,,,%s,,,\"\"\n"
                .format("%.3f".format(suite.getTime().total!"msecs" / 1000.0));
        }
    }
    void print() {
        generate(suite.getTests(), context);
        import std.file;

        write(filename, context);
    }
}

