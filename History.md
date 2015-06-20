Changes
================

0.10.1
----

- Fix typo in bash script via [#54](https://github.com/eddiezane/lunchy/pull/54)


0.10.0
----

- Add bash completion - [bunnymatic](https://github.com/bunnymatic) [alexeyshockov](https://github.com/alexeyshockov) via [#53](https://github.com/eddiezane/lunchy/pull/53)

0.9.0
----

- Add flag for exact match - [bunnymatic](https://github.com/bunnymatic) via [#51](https://github.com/eddiezane/lunchy/pull/51)

0.8.0
----

- Add 'uninstall' command to remove installed plist
- Add '-s, --symlink' option to symlink on install
- Add Rakefile for development
- Make clear that license is MIT, thanks [bf4!](https://github.com/bf4)
- Ignore case on ls, thanks [jpcirrus!](https://github.com/jpcirrus)

0.7.0
----

- Add 'show' command to display contents of matching plist file (jonpierce)
- Add '-l' option on 'ls' command to display absolute paths to plist files (jonpierce)

0.6.0
----

- Fix 'regular expression too big' (jmazzi)
- Allow to force start disabled agents (koraktor)

0.5.0
-----

- Add default output to start and stop (joncooper)
- Add 'edit' command to edit the matching plist file (AndreyChernyh)
- Allow management of daemons in /System/Library/LaunchDaemons when lunchy is run as root (fhemberger)

0.4.0
-----

- Fix install on 1.8.7 (marshally)
- Allow management of daemons in /Library/LaunchDaemons when lunchy is run as root

0.3.0
-----

- New 'install' command to install new plist files (spagalloco)
- Support persistent start/stop
- Fix Ruby 1.8 issues, thanks tmm1!

0.2.0
-----

- Only show agents with plists by default (fhemberger)
- Warn and stop if pattern matches multiple agents (andyjeffries)
- Add 'list', an alias for 'ls' (jnewland)
 
0.1.0
-----

- Initial release
