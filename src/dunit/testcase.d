module dunit.testcase;

import dunit.assertion;

class TestCase : Assert {
protected:
    static void setUpBeforeClass() { }
    static void tearDownAfterClass() { }
    void setUp() { }
    void tearDown() { }
public:
}

