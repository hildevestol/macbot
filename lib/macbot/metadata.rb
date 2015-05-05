require 'yaml'

module Macbot
  VERSION = '0.1.1'
  NAME = 'Macbot'
  SUMMARY = 'Set it up to disable/enable accounts'
  YAML_PATH = 'email.yml'
  EMAIL_GROUPS = YAML.load_file(Macbot::YAML_PATH).keys
end
