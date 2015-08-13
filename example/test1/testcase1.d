module example.test1.testcase1;

import dunit.testcase;
import dunit.expectedexception;

import std.stdio;

class TestException : Exception {
    this(string msg, string file = __FILE__, int line = __LINE__) {
        super(msg, file, line);
    }
}

class ExampleException : Exception {
    this(string msg, string file = __FILE__, int line = __LINE__) {
        super(msg, file, line);
    }
}

class TestCase1 : TestCase {
private:
    static void throwTestException() {
        throw new TestException("Just test it.");
    }
    static void throwExampleException() {
        throw new ExampleException("an example");
    }
protected:
    static void setUpBeforeClass() {
        debug writeln("setUpBeforeClass()");
    }
    static void tearDownAfterClass() {
        debug writeln("tearDownAfterClass()");
    }
    void setUp() {
        debug writeln("setUp()");
    }
    void tearDown() {
        debug writeln("tearDown()");
    }
public:
    void testResult() {
        assertTrue(false);
    }
    void testFalse() {
        assertFalse(false);
    }
    void testEquals() {
        string expected = "bar";
        string actual = "baz";

        assertEquals(expected, actual);
    }
    void testAssocArrayEquals() {
        string[int] expected = [1: "foo", 2: "bar"];
        string[int] actual = [1: "foo", 2: "baz"];

        assertArrayEquals(expected, actual);
    }
    void testRangeEquals() {
        int[] expected = [0, 1, 1, 2];
        auto actual = iota(0, 3);

        assertRangeEquals(expected, actual);
    }
    void testOp() {
        assertLessThan(6 * 3, 42);
    }
    void testException() {
        assertThrow!TestException(&throwTestException, "test");
    }
    void testExceptionFail() {
        assertThrow!TestException(&throwExampleException);
    }
    void testExceptionMessage() {
        assertThrow!ExampleException(&throwExampleException, "two");
    }
}

