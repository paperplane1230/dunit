module dunit.testresult;

class TestResult {
private:
    Exception[string] failureTests;
    Exception[string] errorTests;
    TypeInfo_Class testClass;

    uint sumCount = 0;
    uint failureCount = 0;
    uint errorCount = 0;

public:
    void setTestClass(TypeInfo_Class tested) {
        testClass = tested;
    }
}

