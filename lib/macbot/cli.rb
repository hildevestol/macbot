require 'macbot'
require 'pathname'
require 'yaml'

module Macbot
  class Cli
    require 'commander/import'
    require 'commander/user_interaction'

    program :name, 'macbot'
    program :version, Macbot::VERSION
    program :description, Macbot::SUMMARY

    Macbot::EMAIL_GROUPS.each do |email_group|
      command email_group.to_sym do |c|
        c.syntax = "#{email_group} [options]"
        c.description = "Enable/disable #{email_group}-accounts"
        c.option '--zen', 'Enter zen mode, disable all other accounts'
        c.option '--enable', 'Enable accounts, default true'
        c.option '--disable', 'Disable accounts, default false'
        c.action do |_args, options|
          options.default :enable => true, :disable => false

          if options.enable && options.disable
            abort "You can't both enable and disable the account group"
          end

          applescript Macbot.accounts(email_group, options)
        end
      end
    end

    command :add do |c|
      c.syntax = 'add [options]'
      c.description = 'add values to yml file'
      c.option '--group STRING', String, 'Create email group'
      c.option '--account STING', String, 'Add email to group'
      c.action do |_args, options|
        abort('Missing group') unless options.group
        data = YAML.load_file(Macbot::YAML_PATH)

        unless data[options.group]
          data[options.group] = []
          puts "Created new email group: #{options.group}"
        end

        if options.account
          data[options.group].each do |h|
            if h.to_s == options.account.to_s
              abort "The email #{options.account} is already in group #{options.group}"
            end
          end
          data[options.group] << options.account
          puts "Added #{options.account} to group #{options.group}"
        else
          abort("This group already exist, add email to group by writing \nmacbot add --group #{options.group} --account your email address")
        end

        File.open(Macbot::YAML_PATH, 'w') { |f| YAML.dump(data, f) }
      end
    end

    command :remove do |c|
      c.syntax = 'remove [options]'
      c.description = 'remove values from yml file'
      c.option '--group STRING', String, 'remove email group'
      c.option '--account STING', String, 'remove email from group'
      c.action do |_args, options|
        abort('Missing group') unless options.group
        data = YAML.load_file(Macbot::YAML_PATH)

        if options.account
          data[options.group].each do |e|
            if e.to_s == options.account
              data[options.group].delete(e)
              File.open(Macbot::YAML_PATH, 'w') { |f| YAML.dump(data, f) }
              puts "The email #{options.account} was deleted from group #{options.group}"
            end
          end
        else
          if agree("Are u sure? This will remove affect these emails #{data[options.group]}")
            data.delete(options.group)
            File.open(Macbot::YAML_PATH, 'w') { |f| YAML.dump(data, f) }
            puts "Removed group #{options.group}"
          end
        end
      end
    end

    command :setup do |c|
      c.syntax = 'setup'
      c.description = 'creat yml file'
      c.action do |args, _options|
        if File.exists? Macbot::YAML_PATH
          unless agree('Are u sure? This will reset all your settings')
            abort "Ok, I didn't remove anything"
          end
        end

        file = File.new(Macbot::YAML_PATH, 'w')
        args = %w{work private} unless args.length > 0
        args.each { |arg| file.puts "#{arg}:"}
        file.close
      end
    end

    command :read do |c|
      c.syntax = 'read'
      c.description = 'read yml file'
      c.action do
        puts YAML.load_file(Macbot::YAML_PATH)
      end
    end
  end
end
