xUnit Testing Framework for D
=============================

This is a simple implementation of the xUnit Testing Framework
for the [D Programming Language](http://dlang.org).

Forked from https://github.com/linkrope/dunit, I made some changes so that you can
use it like Junit3.

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
with a `.` for each passed test, an `F` for each failure, an `E` for each error,
and an `S` for each skipped test.

In addition, an XML, CSV or HTML test report is available.

Examples
--------

Run the included [example](example.d) to see the xUnit Testing Framework in action:

    rdmd -Isrc example/example.d

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
