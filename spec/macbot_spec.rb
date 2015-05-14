require 'spec_helper'

describe Macbot do
  it 'has a version number' do
    expect(Macbot::VERSION).not_to be nil
  end

  describe 'disable/enable group' do
    it 'returns applescript for enabling accounts in group' do
      expected_return = <<-END
tell application "Mail"
  set enabled of account "email2@example.com" to true
  set enabled of account "email3@example.com" to true
end tell
      END
      yaml = YAML.load_file('spec/fixtures/.macbot.yml')
      YAML.stub(:load_file).and_return(yaml)

      options = double(enable: true, zen: false)
      expect(Macbot.accounts('work', options )).to eq(expected_return)
    end

    it 'returns applescript for disabling accounts in group' do
      expected_return = <<-END
tell application "Mail"
  set enabled of account "email2@example.com" to false
  set enabled of account "email3@example.com" to false
end tell
      END
      yaml = YAML.load_file('spec/fixtures/.macbot.yml')
      YAML.stub(:load_file).and_return(yaml)

      options = double(enable: false, disable: true, zen: false)
      expect(Macbot.accounts('work', options )).to eq(expected_return)
    end

    it 'returns applescript for enabling accounts in group with zen' do
      expected_return = <<-END
tell application "Mail"
  set enabled of account "email2@example.com" to true
  set enabled of account "email3@example.com" to true
  set enabled of account "email1@example.com" to false
end tell
      END
      yaml = YAML.load_file('spec/fixtures/.macbot.yml')
      YAML.stub(:load_file).and_return(yaml)

      options = double(enable: true, zen: true)
      expect(Macbot.accounts('work', options )).to eq(expected_return)
    end

    it 'returns applescript for disabling accounts in group with zen' do
      expected_return = <<-END
tell application "Mail"
  set enabled of account "email2@example.com" to false
  set enabled of account "email3@example.com" to false
  set enabled of account "email1@example.com" to true
end tell
      END
      yaml = YAML.load_file('spec/fixtures/.macbot.yml')
      YAML.stub(:load_file).and_return(yaml)

      options = double(enable: false, disable: true, zen: true)
      expect(Macbot.accounts('work', options )).to eq(expected_return)
    end
  end
end
