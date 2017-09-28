# Adapted from https://github.com/bronson/vim-runtest/blob/master/rspec_formatter.rb.

require 'rspec/core/formatters/base_formatter'

class VimFormatter < RSpec::Core::Formatters::BaseFormatter
  RSpec::Core::Formatters.register self, :example_failed

  def example_failed(failure)
    example = failure.example
    exception = failure.exception
    path = example.metadata[:file_path]
    line_number = example.metadata[:line_number]
    message = failure.message_lines.join.strip[0, 190]
    output.puts "#{path}:#{line_number}: #{message}"
  end
end
