# Macbot

[![Gem Version](https://badge.fury.io/rb/macbot.svg)](http://badge.fury.io/rb/macbot)

This is a gem for better workflow on you Mac. This only works on OSX and Mail. 
For now the only thing the gem does is Disable and Enables email accounts, but I have planned to add more stuff that I feel wil make it easier to balanse between work and fun on my mac.

## Why this gem?
I often found myself in the situation where I'm at work and personal email keeps flying into my mailbox, or I'm at home enjoying my weekend and work mail keeps flying in. This was really annoying, and manually disable accounts in Mail didn't cut it for me. So this is a gem you can use for disabling and enabling groups of email accounts. 

## Installation


    $ gem install macbot

    $ macbot setup #creates initial yml file
    
A file `.macbot.yml` is created in your home directory. You can edit the file directly or use the commands below to add groups and accounts
    
## Usage
The initial setup has two groups: work and privat, but you can create your own groups and manage them as you like

### Add a group

    $ macbot add --group yourGroupName
    
### Add email to a group

**Important:** account must be name of your emailaccount in Mail

    $ macbot add --group yourGroupName --account youAccountName


### Disable/Enable accounts

If your config is the following
````yaml
work:
- work1
- work2
private:
- private1
- private2
someother:
- other1
- other2
````      
And u simply want to enable your work accounts

    $ macbot work --enable
    
or u want to enable your work accounts, and disable all other accounts

    $ macbot work --enable --zen
    
or u want to disable your work accounts

    $ macbot work --disable
    
All the commands can be found in 

    $ macbot --help
    
Commands directly to your email group

    $ macbot work --help
    $ macbot [group] --help


## Contributing

1. Fork it ( https://github.com/[my-github-username]/macbot/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
