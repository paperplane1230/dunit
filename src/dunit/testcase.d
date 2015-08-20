module dunit.testcase;

import dunit.assertion;
import dunit.testresult;

import core.thread;
import std.traits;

class TestCase : Assert {
private:
    TestResult result = new TestResult();

    bool beforeTest = true;
    bool afterTest = true;

    bool startWith(in string source, in string target) {
        return source.length >= target.length 
            && source[0..target.length] == target;
    }

protected:
    override void run() {
        if (beforeTest) {
            beforeTest = false;
            try {
                setUpBeforeClass();
            } catch (Exception e) {
                result.addError("setUpBeforeClass", e);
                return;
            }
        }
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
            try {
                setUp();
            } catch (Exception e) {
                result.addError(method, e);
            }
        }
    }
public:
    this() {
        result.setTestClass(this.classinfo);
    }

    void setUpBeforeClass() { }
    void tearDownAfterClass() { }
    void setUp() {  }
    void tearDown() {  }
}

