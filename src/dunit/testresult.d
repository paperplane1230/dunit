module dunit.testresult;

class TestResult {
private:
    Exception[string] failureTests;
    Exception[string] errorTests;

    TypeInfo_Class testClass;
    uint sumCount = 0;
public:
    this(TypeInfo_Class tested) {
        testClass = tested;
    }

    void addError(in string error, Exception e) {
        errorTests[testClass.name ~ "." ~ error] = e;
    }
    void addFailure(in string failure, Exception e) {
        failureTests[testClass.name ~ "." ~ failure] = e;
    }

    void setSum(uint sum) {
        sumCount = sum;
    }
    uint getSum() {
        return sumCount;
    }
    Exception[string] getFailures() {
        return failureTests;
    }
    Exception[string] getErrors() {
        return failureTests;
    }
    TypeInfo_Class getClass() {
        return testClass;
    }
}

