Intro
=====

This repository is where I am keeping tests for assignment 4 for CS 453. There is also a test harness. To get started, just clone this repo:

    git clone https://github.com/srawlins/cs453-assignment4-tests

Then add your `compile` to your `$PATH`, and run `go-test-now.sh`. Alternatively, you can pass in the desired program to test as the first argument to `go-test-now.sh`.

How it Works
============

The test harness works as follows: `compile` must be in your `$PATH` (or must be passed in as the first argument), so that it can be executed against the test files. Inside this repository is a `testcases` directory, with three groups of files inside: (1) a group of `.cmm` files which will each serve as input, (2) a group of `.out` files which each contain the expected standard output of running `compile` against the respective input file, and (3) a group of `.error_lines` files which will each serve as a newline-separated list of line numbers that your program should print to standard out, upon error. For example, `spec_3.1-7_01.cmm` is an example input file (for Typing Rules 3.1, Rule 7), and `spec_3.1-7_01.out` is the sibling expected output file, and `spec_3.1-7_01.error_lines` is the list of lines with errors.

As `compile` is run against each input file, the output is compared to the respective expected output file. If the outputs match, you get a fun, green dot. If not, you get a big red F, and a diff at the end, comparing the expected and real output.

Feel free to add your own input and expected output files, and they will be automatically run by the harness.

Error Line Numbers
==================

Without knowing exactly the text that your program will output for any error, how can we test your program for such errors?

The `.error_lines` files contain a list of unique line numbers that have errors on them. The stderr of your program is parsed for numbers, in a rather crude way, and then `uniq`ed. So that if your program errors on lines 1,2,3,3,3,3,3, and the `.error_lines` file contains 1, 2, and 3, then the test will succeed.

Some test files do have multiple errors per line, such as `spec_3.2-5_01.cmm`, but this test suite is not going to test for the right number.

Contributing
============

To contribute a test back to this repository, make sure to generate the expected output files and expected error lines files, and send me a pull request.

To contribute to the harness, make sure to test whatever first.
