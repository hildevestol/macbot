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

    command :add do |c|
      c.syntax = 'add [options]'
      c.description = 'add values to yml file'
      c.option '--group STRING', String, 'Create email group'
      c.option '--email STING', String, 'Add email to group'
      c.action do |args, options|
        abort("Missing group") unless options.group
        data = YAML.load_file(Macbot::YAML_PATH)

        unless data[options.group]
          data[options.group] = []
          puts "Created new email group: #{options.group}"
        end

        if options.email
          data[options.group].each do |h|
            if h.to_s == options.email.to_s
              abort "The email #{options.email} is already in group #{options.group}"
            end
          end
          data[options.group] << options.email
          puts "Added #{options.email} to group #{options.group}"
        else
          abort("This group already exist, add email to group by writing \nmacbot add --group #{options.group} --email your email address")
        end

        File.open(Macbot::YAML_PATH, 'w') { |f| YAML.dump(data, f) }
      end
    end

    command :remove do |c|
      c.syntax = 'remove [options]'
      c.description = 'remove values from yml file'
      c.option '--group STRING', String, 'remove email group'
      c.option '--email STING', String, 'remove email from group'
      c.action do |args, options|
        abort("Missing group") unless options.group
        data = YAML.load_file(Macbot::YAML_PATH)

        if options.email
          data[options.group].each do |e|
            if e.to_s == options.email
              data[options.group].delete(e)
              File.open(Macbot::YAML_PATH, 'w') { |f| YAML.dump(data, f) }
              puts "The email #{options.email} was deleted from group #{options.group}"
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
      c.action do |args, options|
        if File.exists? Macbot::YAML_PATH
          unless agree("Are u sure?")
            abort "Ok, I didn't remove anything"
          end
        end
        out_file = File.new(Macbot::YAML_PATH, "w")
        out_file.puts('work:')
        out_file.puts('private:')
        out_file.close
      end
    end

    command :read do |c|
      c.syntax = 'read'
      c.description = 'read yml file'
      c.action do |args, options|
        data = YAML.load_file(Macbot::YAML_PATH)
        puts data
      end
    end
  end
end
