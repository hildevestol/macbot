require 'macbot/metadata'
require 'yaml'

module Macbot
  # Your code goes here...

  MAIL_START = <<-END
      tell application "Mail"
  END

  MAIL_END = <<-END
      end tell
  END

  def self.accounts(type, options)
    enable = enabled(options)
    data = YAML.load_file(Macbot::YAML_PATH)
    emails = data[type]
    string = ''
    string += build_string(emails, enable)
    string += enable_zen(type, enable, data) if options.zen

    MAIL_START + string + MAIL_END
  end

  private

  def self.enabled(options)
    return true if options.enable
    return false if options.disable
    puts 'what?'
  end

  def self.enable_zen(type, enable, data)
    puts 'enable zen mode'
    string = ''
    Macbot::EMAIL_GROUPS.each do |group|
      string += build_string(data[group], !enable) unless group == type
    end
    string
  end

  def self.build_string(arr, enable)
    string = ''
    arr.each do |account|
      puts "set #{account} to #{enable}"
      string << <<-END
        set enabled of account "#{account.to_s}" to #{enable}
      END
    end
    string
  end
end
