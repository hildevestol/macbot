require 'macbot'
require 'pathname'

module Macbot
  class Cli
    require 'commander/import'
    require 'commander/user_interaction'

    program :name, 'macbot'
    program :version, Macbot::VERSION
    program :description, Macbot::SUMMARY

    Macbot::EMAIL_GROUPS.each do |type|
      command type.to_sym do |c|
        c.syntax = "#{type} [options]"
        c.description = "Enable/disable #{type}-accounts"
        c.option '--zen', 'Enter zen mode, disable all other accounts'
        c.option '--enable', 'Enable accounts'
        c.option '--disable', 'Disable accounts'
        c.action do |_args, options|
          applescript Macbot.accounts(type, options)
        end
      end
    end
  end
end
