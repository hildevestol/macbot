require 'macbot/metadata'
require 'yaml'

module Macbot
  def self.accounts(type, options)
    enable = enabled(options)
    data = YAML.load_file(Macbot::YAML_PATH)
    emails = data[type]
    string = build_string(emails, enable)
    string += enable_zen(type, enable, data) if options.zen

    <<-END
      tell application "Mail"
        #{string}
      end tell
    END
  end

  private

  def self.enabled(options)
    return true if options.enable
    return false if options.disable
    puts 'what?'
  end

  def self.enable_zen(type, enable, data)
    puts 'enable zen mode'
    Macbot::EMAIL_GROUPS.map do |group|
      build_string(data[group], !enable) unless group == type
    end.join
  end

  def self.build_string(arr, enable)
    arr.map do |account|
      puts "set #{account} to #{enable}"
      <<-END
        set enabled of account "#{account}" to #{enable}
      END
    end.join
  end
end
