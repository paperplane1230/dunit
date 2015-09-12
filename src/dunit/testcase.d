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
    final static TestResult run(alias T)(string name) {
        T test = new T();
        TestResult result = new TestResult(typeid(T));

        result.setSuiteName(name);
        TickDuration startTime = TickDuration.currSystemTick();

        try {
            test.before();
        } catch (AssertException e) {
            Duration elapsedTime
                = cast(Duration)(TickDuration.currSystemTick() - startTime);

            result.addFailure("before", e, elapsedTime);
            return result;
        } catch (Throwable e) {
            Duration elapsedTime
                = cast(Duration)(TickDuration.currSystemTick() - startTime);

            result.addError("before", e, elapsedTime);
            return result;
        }
        Duration elapsedTime
            = cast(Duration)(TickDuration.currSystemTick() - startTime);

        result.addTest("before", elapsedTime);
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
                startTime = TickDuration.currSystemTick();
                try {
                    test.setUp();
                } catch (AssertException e) {
                    elapsedTime = cast(Duration)
                                    (TickDuration.currSystemTick() - startTime);
                    result.addFailure(method, e, elapsedTime);
                    continue;
                } catch (Throwable e) {
                    elapsedTime = cast(Duration)
                                    (TickDuration.currSystemTick() - startTime);
                    result.addError(method, e, elapsedTime);
                    continue;
                }
                try {
                    // invoke the method
                    __traits(getMember, test, method)();
                    result.addTest(method);
                } catch (AssertException e) {
                    result.addFailure(method, e);
                } catch (Throwable e) {
                    result.addError(method, e);
                } finally {
                    runRemaining(&test.tearDown);
                    elapsedTime = cast(Duration)
                                    (TickDuration.currSystemTick() - startTime);
                    result.setTime(method, elapsedTime);
                }
            }
        }
        startTime = TickDuration.currSystemTick();
        try {
            test.after();
        } catch (Throwable e) {
            // leave it here, do nothing
            ;
        }
        elapsedTime = cast(Duration)(TickDuration.currSystemTick() - startTime);
        result.addTest("after", elapsedTime);
        return result;
    }
}

