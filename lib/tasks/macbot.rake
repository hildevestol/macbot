require "highline/import"
require 'yaml'
require 'macbot/metadata'

namespace :macbot do
  namespace :add do
    desc 'Create email group'
    task :group, [:name, :arne] do |t, args|
      data = YAML.load_file(Macbot::YAML_PATH)
      abort "This group already exist, add email to group by writing \nrake macbot:add:email[#{args[:name]}][your email address]" if data["#{args[:name]}"]
      data["#{args[:name]}"] = []
      File.open(Macbot::YAML_PATH, 'w') { |f| YAML.dump(data, f) }
      puts "Created new email group: #{args[:name]}"
    end

    desc 'Add email to group'
    task :email, [:group, :email] do |t, args|
      data = YAML.load_file(Macbot::YAML_PATH)

      unless data["#{args[:group]}"]
        puts "Group #{args[:group]} didn't exist, but I created it for You"
        data["#{args[:group]}"] = []
      end

      data["#{args[:group]}"].each do |h|
        if h.to_s == args[:email].to_s
          abort "The email #{args[:email]} is already in group #{args[:group]}"
        end
      end

      data["#{args[:group]}"] << args[:email]
      puts "Added #{args[:email]} to group #{args[:group]}"
      File.open(Macbot::YAML_PATH, 'w') { |f| YAML.dump(data, f) }
    end
  end

  namespace :remove do
    desc 'Remove entire group'
    task :group, [:group] do |t, args|
      data = YAML.load_file(Macbot::YAML_PATH)
      if agree("Are u sure? This will remove affect these emails #{data[args[:group]]}")
        data.delete("#{args[:group]}")
        File.open(Macbot::YAML_PATH, 'w') { |f| YAML.dump(data, f) }
        puts "Removed group #{args[:group]}"
      else
        puts "Ok, I didn't remove anything"
      end
    end

    desc 'Remove email from group'
    task :email, [:group, :email] do |t, args|
      data = YAML.load_file(Macbot::YAML_PATH)
      data["#{args[:group]}"].each do |h|
        if h.to_s == args[:email].to_s
          data["#{args[:group]}"].delete(h)
          File.open(Macbot::YAML_PATH, 'w') { |f| YAML.dump(data, f) }
          puts "The email #{args[:email]} was deleted from group #{args[:group]}"
        end
      end
    end
  end

  desc 'Create yml file'
  task :setup do
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

  desc 'dumps entire info'
  task :read do
    data = YAML.load_file(Macbot::YAML_PATH)
    puts data
  end
end
