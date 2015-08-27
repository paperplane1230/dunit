module example.test2.testcase2;

import dunit.testcase;

import core.thread;
import core.time;

/**
 * This example demonstrates how to test asynchronous code.
 */
class TestCase2 : TestCase {
private:
    Thread thread;
    bool done;

    void threadFunction() {
        Thread.sleep(msecs(100));
        done = true;
    }
public:
    void setUp() {
        done = false;
        thread = new Thread(&threadFunction);
    }

    void tearDown() {
        thread.join();
    }

    void test() {
        assertFalse(done);
        thread.start();
        assertEventually({ return done; });
    }
}

