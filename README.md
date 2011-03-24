lunchy
=================

A friendly wrapper for launchctl.  Start your agents and go to lunch!

Don't you hate OSX's launchctl?  You have to give it exact filenames.  The syntax is annoying different from Linux's simple init system and overly verbose.  It's just not a very developer-friendly tool.

Lunchy aims to be that friendly tool by wrapping launchctl and providing a few simple operations that you perform all the time:

 - ls [pattern]
 - start [pattern]
 - stop [pattern]
 - restart [pattern]
 - status [pattern]
 
where pattern is just a substring that matches the agent's plist filename.  Make sure you use a unique pattern or Lunchy will operate on the first matching agent.

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

Lunchy isn't a great name but gem names are like domains, most of the good ones are taken.  :-(


Installation
---------------

    gem install lunchy

Lunchy is written in Ruby because I'm a good Ruby developer and a poor Bash developer.  Help welcome.


About
-----------------

Mike Perham, [@mperham](http://twitter.com/mperham), [mikeperham.com](http://mikeperham.com/)