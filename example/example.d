#!/usr/bin/env rdmd -Isrc

module example.example;

import example.test1.testsuite1;
import example.test2.testsuite2;
import dunit.testsuite;
import dunit.testrunner;

debug {
    import std.stdio;
}

TestSuite suite()
{
    TestSuite suite = new TestSuite();

    suite.addTest(TestSuite1.suite());
    suite.addTest(TestSuite2.suite());
    return suite;
}

void main(string[] args)
{
    TestRunner.run(suite(), args);
}

