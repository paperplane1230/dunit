xUnit Testing Framework for D
=============================

This is a simple implementation of the xUnit Testing Framework
for the [D Programming Language](http://dlang.org).

Forked from https://github.com/linkrope/dunit, I made some changes so that you can
use it like JUnit3.

First, you write a new class derived from TestCase, where there are many assertions
to use to meet your demand. You write your functions for testing in the new class.
Then, you can add it to a TestSuite. Last, use TestRunner to run the suite with
parameters passed by the command line. For details, you can have a look at the
example.

I preserved assertion.d and diff.d and add some assertions. However, now functions
in assertion.d have been members of TestCase.

Test Results
------------

Test results are reported while the tests are run. A "progress bar" is written
with a `.` for each passed test, an `F` for each failure and an `E` for each error.

In addition, an XML, CSV or HTML test report is available, using --xml/csv/html filename.

Examples
--------

Run the included [example](example.d) to see the xUnit Testing Framework in action:

    rdmd -Isrc example/example.d

Notes
-----

The semantics of addTestSuite is a little different from that in JUnit. As you can
see in the source code, it run the testcase at once for I have spent lots of time
dealing with the reflection. I can't make it without using the mixin template, which
I don't want to see in the project. Maybe I can fix it in the future.

Another thing, only one instance of testcase is used when running tests. While in JUnit,
it generates an instance for each method in the testcase to run. What's more, before()
and after() work differently from @BeforeClass and @AfterClass in JUnit4. For example,
before() was invoked before any method in the testcase, but after the instance was
constructed.

Related Projects
----------------

- [DMocks-revived](https://github.com/QAston/DMocks-revived):
  a mock-object framework that allows to mock interfaces or classes
- [specd](https://github.com/jostly/specd):
  a unit testing framework inspired by [specs2](http://etorreborre.github.io/specs2/)
  and [ScalaTest](http://www.scalatest.org)
- [DUnit](https://github.com/kalekold/dunit):
  a toolkit of test assertions and a template mixin to enable mocking
- [unit-threaded](https://github.com/atilaneves/unit-threaded):
  a multi-threaded unit testing framework
