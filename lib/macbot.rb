require 'macbot/metadata'

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
    const = const_get type.upcase

    string = ''
    string += build_string(const, enable)
    string += enable_zen(const, enable) if options.zen

    MAIL_START + string + MAIL_END
  end

  private

  def self.enabled(options)
    return true if options.enable
    return false if options.disable
    puts 'what?'
  end

  def self.enable_zen(const, enable)
    puts 'enable zen mode'
    build_string((Macbot::EMAIL_GROUPS - const), !enable)
  end

  def self.build_string(arr, enable)
    string = ''
    arr.each do |account|
      puts "set #{account} to #{enable}"
      string << <<-END
        set enabled of account "#{account}" to #{enable}
      END
    end
    string
  end
end
