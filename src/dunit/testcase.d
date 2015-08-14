module dunit.testcase;

import dunit.assertion;

class TestCase : Assert {
public:
    static void setUpBeforeClass() { }
    static void tearDownAfterClass() { }
    void setUp() { }
    void tearDown() { }
}

