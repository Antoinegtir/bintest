# Binary Testor

Binary Testor is a command-line tool for running tests on binary executables. It allows you to define a set of tests with expected outputs and exit codes and automatically executes them, providing a summary of the test results.

<img src="https://skillicons.dev/icons?i=ruby"/>

## Usage

Install Ruby: Binary Testor is written in Ruby, so ensure that Ruby is installed on your system.
Install dependencies: Run `bundle install` to install the required dependencies specified in the `Gemfile`.
Prepare the TOML configuration file: Create a TOML file that defines your tests. The file should contain a table called "test", and each test should have the following properties:
- name: A descriptive name for the test.
- command: The command to run the binary executable.
- expected_stdout: The expected standard output of the test.
- expected_stderr: The expected standard error of the test.
- expected_exit_code: The expected exit code of the test.
- time_out (optional): The timeout duration for the test in seconds (default: 5 seconds).

Example TOML file (ftest.toml):

<img src="https://github.com/Antoinegtir/bintest/blob/main/screenshot/toml.png"></img>

Run Binary Testor: Execute the following command in the terminal:

`ruby engine.rb`

or use rules of Rakefile such as `rake`, `rake clean`

Binary Testor will load the configuration file, execute each test, and display the results.
If a test passes, it will be marked as "Passed" in green.
If a test fails, it will be marked as "Failed" in red, and the differences between the expected and actual outputs will be displayed.
If a test exceeds the specified timeout duration, it will be marked as "Crashed" in red.
Review the test results: After all tests have been executed, Binary Testor will display a summary of the test results, including the number of tests passed, the number of tests crashed, and the overall success rate.

## Example output:

<img src="https://github.com/Antoinegtir/bintest/blob/main/screenshot/notpassed.png"></img>

<img src="https://github.com/Antoinegtir/bintest/blob/main/screenshot/passed.png"></img>

That's it! You can now use Binary Testor to automate the testing of your binary executables and ensure they produce the expected results.

Note: Make sure the binary executable is present and accessible in the same directory where you run Binary Testor, or specify the full path to the executable in the command property of each test.

Enjoy!
