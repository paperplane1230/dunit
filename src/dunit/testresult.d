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
        errorTests[error] = e;
    }

    void addFailure(in string failure, Exception e) {
        failureTests[failure] = e;
    }

    void setSum(uint sum) {
        sumCount = sum;
    }
}

