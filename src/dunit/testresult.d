module dunit.testresult;

import core.time;

debug {
    import std.stdio;
}

class TestResult {
private:
    Throwable[string] failureTests;
    Throwable[string] errorTests;
    Duration[string] elapsedTime;
    string[] caseNames;

    TypeInfo_Class testClass;
    Duration totalTime;
    string sign;

    void setNameAndTime(string name, Duration time) {
        elapsedTime[name] = time;
        totalTime += time;
    }
public:
    this(TypeInfo_Class tested) {
        testClass = tested;
    }

    void addTest(string test, Duration time = 0.msecs) {
        caseNames ~= test;
        string name = testClass.name ~ "." ~ test;

        setNameAndTime(name, time);
        sign ~= ".";
    }
    void addError(string error, Throwable e, Duration time = 0.msecs) {
        caseNames ~= error;
        string name = testClass.name ~ "." ~ error;

        setNameAndTime(name, time);
        errorTests[name] = e;
        sign ~= "E";
    }
    void addFailure(string failure, Throwable e, Duration time = 0.msecs) {
        caseNames ~= failure;
        string name = testClass.name ~ "." ~ failure;

        setNameAndTime(name, time);
        failureTests[name] = e;
        sign ~= "F";
    }

    void setTime(string caseName, Duration time) {
        string name = testClass.name ~ "." ~ caseName;

        totalTime -= elapsedTime[name];
        elapsedTime[name] = time;
        totalTime += time;
    }
    Duration getTime(string caseName) {
        string name = testClass.name ~ "." ~ caseName;

        return elapsedTime[name];
    }
    Duration getTotalTime() {
        return totalTime;
    }
    ulong getSum() {
        return caseNames.length;
    }
    string getSign() {
        return sign;
    }
    Throwable[string] getFailures() {
        return failureTests;
    }
    Throwable[string] getErrors() {
        return errorTests;
    }
    Throwable getError(string error) {
        error = testClass.name ~ "." ~ error;
        if (error !in errorTests) {
            return null;
        }
        return errorTests[error];
    }
    Throwable getFailure(string failure) {
        failure = testClass.name ~ "." ~ failure;
        if (failure !in failureTests) {
            return null;
        }
        return failureTests[failure];
    }
    string getClass() {
        return testClass.name;
    }
    string[] getCases() {
        return caseNames;
    }
}

