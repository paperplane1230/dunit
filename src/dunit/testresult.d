module dunit.testresult;

import core.time;

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
        caseNames ~= name;
        elapsedTime[name] = time;
        totalTime += time;
    }
public:
    this(TypeInfo_Class tested) {
        testClass = tested;
    }

    void addTest(string test, Duration time = 0.msecs) {
        string name = testClass.name ~ "." ~ test;

        setNameAndTime(name, time);
        sign ~= ".";
    }
    void addError(string error, Throwable e, Duration time = 0.msecs) {
        string name = testClass.name ~ "." ~ error;

        setNameAndTime(name, time);
        errorTests[name] = e;
        sign ~= "E";
    }
    void addFailure(string failure, Throwable e, Duration time = 0.msecs) {
        string name = testClass.name ~ "." ~ failure;

        setNameAndTime(name, time);
        failureTests[name] = e;
        sign ~= "F";
    }

    void setTime(string caseName, Duration time) {
        string name = testClass.name ~ "." ~ caseName;

        totalTime -= elapsedTime[name];
        elapsedTime[caseName] = time;
        totalTime += time;
    }
    Duration getTime(string caseName) {
        return elapsedTime[caseName];
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
    TypeInfo_Class getClass() {
        return testClass;
    }
}

