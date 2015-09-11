module dunit.testresult;

import core.time;

class TestResult {
private:
    Throwable[string] failureTests;
    Throwable[string] errorTests;

    TypeInfo_Class testClass;
    Duration elapsedTime;
    string sign;
    uint sumCount = 0;
public:
    this(TypeInfo_Class tested) {
        testClass = tested;
    }

    void addError(in string error, Throwable e) {
        errorTests[testClass.name ~ "." ~ error] = e;
    }
    void addFailure(in string failure, Throwable e) {
        failureTests[testClass.name ~ "." ~ failure] = e;
    }
    void addSign(in string s) {
        sign ~= s;
    }

    void setTime(Duration time) {
        elapsedTime = time;
    }
    Duration getTime() {
        return elapsedTime;
    }
    void setSum(uint sum) {
        sumCount = sum;
    }
    uint getSum() {
        return sumCount;
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

