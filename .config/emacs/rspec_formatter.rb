#!/usr/bin/env ruby
#
Formatters = RSpec::Core::Formatters

class EmacsRspecFormatter < Formatters::DocumentationFormatter
  Formatters.register self, :dump_summary

  def dump_summary(*); end
end
