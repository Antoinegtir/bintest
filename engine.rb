require 'toml-rb'
require 'timeout'

if (ARGV.length == 1)
  file = ARGV[0]
else
  file = "ftest.toml"
end
count = 0
total = 0
crashes = 0

begin
  config = TomlRB.load_file(file)
rescue Errno::ENOENT
  puts "Erreur : Le fichier #{file} n'a pas été trouvé."
  exit (84)
rescue TomlRB::ParseError
  puts "Erreur : Le fichier #{file} n'est pas un fichier TOML valide."
  exit (84)
end

tests = config['test']

if tests.nil?
  puts "Erreur : Aucune configuration 'test' trouvée dans le fichier #{file}."
  exit
end

tests.each do |test|
  name = test['name']
  command = test['command']
  expected_stdout = test['expected_stdout']
  expected_stderr = test['expected_stderr']
  expected_exit_code = test['expected_exit_code']
  time_out = test['time_out'] || 5

  if name.nil? || command.nil? || expected_stdout.nil? || expected_stderr.nil? || expected_exit_code.nil?
    puts "Erreur : Paramètre(s) manquant(s) pour le test '#{name}' dans le fichier #{file}."
    exit(84)
  end
end

tests = TomlRB.load_file(file)['test']
tests.each do |test|
  name = test['name']
  command = test['command']
  expected_stdout = test['expected_stdout']
  expected_stderr = test['expected_stderr']
  expected_exit_code = test['expected_exit_code']
  time_out = test['time_out'] || 5
  begin
    Timeout.timeout(time_out) do
      output = `#{command} 2>&1`
      exit_code = $?.exitstatus
      actual_stdout, actual_stderr = output.split("\n", 2)
      total += 1
      if expected_stdout == "--skip"
        expected_stdout = actual_stdout
      end
      if actual_stdout.strip == expected_stdout.strip && exit_code == expected_exit_code && actual_stderr.strip == expected_stderr.strip
        puts "\n\033[0;32m➜ #{name} - Passed ✅\033[0m"
        count += 1
      else
        puts "\n\033[0;31m➜ #{name} - Failed 🚫\033[0m"
        if actual_stdout.strip != expected_stdout.strip
          puts "Expected stdout:"
          puts "  -> "+expected_stdout
          puts "Actual stdout:"
          puts "  -> "+actual_stdout
        end
        if exit_code != expected_exit_code
          puts "Expected exit code: #{expected_exit_code}"
          puts "Actual exit code: #{exit_code}"
        end
        if actual_stderr.strip != expected_stderr.strip
          puts "Expected stderr:"
          puts expected_stderr
          puts "Actual stderr:"
          puts actual_stderr
        end
      end
    end
  rescue Timeout::Error
    print_separator
    puts "\033[0;31m#{name} - Crashed ⛔\033[0m"
    crashes += 1
    print_separator
  end
end
if count == total
  puts "\n\033[0;33m#{count}/#{total} tests passed | #{crashes} tests crashed 🚫\033[0m"
else
  puts "\n\033[0;33m#{count}/#{total} tests passed | #{crashes}/#{total} tests crashed\033[0m"
end
