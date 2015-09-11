module dunit.testcase;

import dunit.assertion;
import dunit.testresult;

import std.traits;
import core.time;

bool startWith(in string source, in string target)
{
    return source.length >= target.length 
        && source[0..target.length] == target;
}

class TestCase : Assert {
private:
    // do tearDown because we can't put catch inside finally block
    static void runRemaining(void delegate() func) {
        try {
            func();
        } catch (Throwable e) {
            // leave it here, do nothing
            ;
        }
    }
protected:
    void before() { }
    void after() { }
    void setUp() { }
    void tearDown() { }
public:
    final static TestResult run(alias T)() {
        T test = new T();
        TestResult result = new TestResult(typeid(T));
        TickDuration startTime = TickDuration.currSystemTick();

        try {
            test.before();
        } catch (AssertException e) {
            Duration elapsedTime
                = cast(Duration)(TickDuration.currSystemTick() - startTime);
            result.addFailure("before", e);
            result.setTime(elapsedTime);
            result.addSign("F");
            return result;
        } catch (Throwable e) {
            Duration elapsedTime
                = cast(Duration)(TickDuration.currSystemTick() - startTime);
            result.addError("before", e);
            result.setTime(elapsedTime);
            result.addSign("E");
            return result;
        }
        uint sumTests = 0;

        foreach (method; __traits(derivedMembers, T)) {
            // make sure method is a function, not a field
            static if (__traits(getProtection,
                        __traits(getMember, test, method)) == "public"
                    && isCallable!(__traits(getMember, test, method))) {
                // judge whether the method satisfy the format "void testXXX()"
                static if (!startWith(method, "test")
                        || ParameterTypeTuple!(__traits(getMember, test, method))
                            .length != 0
                        || ReturnType!(__traits(getMember, test, method))
                            .stringof != "void") {
                    continue;
                }
                ++sumTests;
                try {
                    test.setUp();
                } catch (AssertException e) {
                    result.addFailure("setUp", e);
                    result.addSign("F");
                    continue;
                } catch (Throwable e) {
                    result.addError("setUp", e);
                    result.addSign("E");
                    continue;
                }
                try {
                    // invoke the method
                    __traits(getMember, test, method)();
                    result.addSign(".");
                } catch (AssertException e) {
                    result.addFailure(method, e);
                    result.addSign("F");
                } catch (Throwable e) {
                    result.addError(method, e);
                    result.addSign("E");
                } finally {
                    runRemaining(&test.tearDown);
                }
            }
        }
        result.setSum(sumTests);
        try {
            test.after();
        } catch (Throwable e) {
            // leave it here, do nothing
            ;
        }
        Duration elapsedTime
            = cast(Duration)(TickDuration.currSystemTick() - startTime);
        result.setTime(elapsedTime);
        return result;
    }
}

