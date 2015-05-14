require 'yaml'

module Macbot
  VERSION = '0.1.5'
  NAME = 'Macbot'
  SUMMARY = 'Set it up to disable/enable email accounts in Mail for OSX'
  YAML_PATH = File.join(Dir.home, '/.macbot.yml')
  EMAIL_GROUPS = YAML.load_file(Macbot::YAML_PATH).keys rescue []
end
