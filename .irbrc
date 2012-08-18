require 'irb/completion'
require 'irb/ext/save-history'

IRB.conf[:PROMPT_MODE] = :SIMPLE
IRB.conf[:SAVE_HISTORY] = 10000
IRB.conf[:HISTORY_FILE] = if defined?(Rails)
                            Rails.root.join('tmp', '.irb_history')
                          elsif defined?(RAILS_ROOT)
                            File.join(RAILS_ROOT, 'tmp', '.irb_history')
                          else
                            "#{ENV['HOME']}/.irb_history"
                          end
