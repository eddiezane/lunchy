# lunchy

A friendly wrapper for launchctl.  Start your agents and go to lunch!

Don't you hate OSX's launchctl?  You have to give it exact filenames, the syntax is annoyingly different from Linux's, and it is overly verbose.  It's just not a very developer-friendly tool.

Lunchy aims to be that friendly tool by wrapping launchctl and providing a few simple operations that you perform all the time:

 - ls [pattern]
 - start [pattern]
 - stop [pattern]
 - restart [pattern]
 - status [pattern]
 - install [file]
 - uninstall [pattern]
 - show [pattern]
 - edit [pattern]

where pattern is just a substring that matches the agent's plist filename.  If you don't use a unique pattern, Lunchy will warn you of this and give you a list of the matching items instead.

So instead of:

    launchctl load ~/Library/LaunchAgents/io.redis.redis-server.plist

you can do this:

    lunchy start redis

and:

    > lunchy ls
    com.danga.memcached
    com.google.keystone.agent
    com.mysql.mysqld
    io.redis.redis-server
    org.mongodb.mongod

The original name was supposed to be launchy.  Lunchy isn't a great name but gem names are like domains, most of the good ones are taken.  :-(


## Installation

### Using RubyGems

    gem install lunchy

Lunchy is written in Ruby because I'm a good Ruby developer and a poor Bash developer.  Help is welcome.

### Using Homebrew

    brew install lunchy

## Thanks

Thanks to all the individual contributors who've improved Lunchy, see credits in History.md.

Lunchy was written as part of my project time at [Carbon Five](http://carbonfive.com).  [They're hiring](http://www.carbonfive.com/careers/) if you love working on Ruby and open source.


## About

Mike Perham, [@mperham](http://twitter.com/mperham), [mikeperham.com](http://mikeperham.com/)
