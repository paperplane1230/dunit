module dunit.testcase;

import dunit.assertion;
import dunit.testresult;

import core.thread;
import std.traits;

class TestCase : Assert {
private:
    TestResult result = new TestResult(this.classinfo);

    bool startWith(in string source, in string target) {
        return source.length >= target.length 
            && source[0..target.length] == target;
    }
protected:
    void before() { }
    void after() { }
    void setUp() { }
    void tearDown() { }

    override void run() {
        try {
            before();
        } catch (Exception e) {
            result.addError("before", e);
            return;
        }
        uint sumTests = 0;

        foreach (method; __traits(derivedMembers, this)) {
            // to judge whether the method satisfy the format "void testXXX()"
            if (!method.startWith("test")
                    || __traits(getProtection, method) != "public"
                    || ParameterTypeTuple!(__traits(getMember, this, method))
                        .length != 0
                    || ReturnType!(__traits(getMember, this, method))
                        .stringof != "void") {
                continue;
            }
            ++sumTests;
            try {
                setUp();
            } catch (Exception e) {
                result.addError("setUp", e);
                continue;
            }
            try {
                // invoke the method
                __traits(getMember, this, method)();
            } catch (Exception e) {
                result.addFailure(method, e);
            } finally {
                try {
                    tearDown();
                } catch (Exception e) {
                    // leave it here, do nothing
                    ;
                }
            }
        }
        result.setSum(sum);
        try {
            after();
        } catch (Exception e) {
            // leave it here, do nothing
            ;
        }
    }
public:
}

