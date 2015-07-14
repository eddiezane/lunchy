# -*- encoding: utf-8 -*-
require "./lib/lunchy"

post_install_message = <<-EOS
-------

Thanks for installing Lunchy.  We know you're going to love it!

If you want to add tab-completion (for bash), add the following 
to your .bash_profile, .bashrc or .profile

   LUNCHY_DIR=$(dirname `gem which lunchy`)/../extras
   if [ -f $LUNCHY_DIR/lunchy-completion.bash ]; then
     . $LUNCHY_DIR/lunchy-completion.bash
   fi

or add the following to your .zshrc for ZSH

  LUNCHY_DIR=$(dirname `gem which lunchy`)/../extras
  if [ -f $LUNCHY_DIR/lunchy-completion.zsh ]; then
    . $LUNCHY_DIR/lunchy-completion.zsh
  fi

-------
EOS

Gem::Specification.new do |s|
  s.name        = "lunchy"
  s.version     = Lunchy::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Mike Perham", "Eddie Zaneski", "Mr Rogers"]
  s.email       = ["mperham@gmail.com"]
  s.homepage    = "http://github.com/eddiezane/lunchy"
  s.summary     = s.description = %q{Friendly wrapper around launchctl}
  s.post_install_message = post_install_message
  s.licenses    = ['MIT']

  s.add_development_dependency "rake"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
