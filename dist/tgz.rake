require 'digest'

# Used part of Heroku script https://github.com/heroku/heroku
#
file pkg("lunchy-#{version}.tgz") => distribution_files("tgz") do |t|
  tempdir do |dir|
    mkchdir("lunchy") do
      assemble_distribution
      assemble_gems
      assemble resource("tgz/lunchy"), "bin/lunchy", 0755
    end
    ` chmod -R go+r lunchy `
    ` tar czf #{t.name} lunchy `
  end
end

file pkg("lunchy-#{version}.tgz.sha256") => pkg("lunchy-#{version}.tgz") do |t|
  File.open(t.name, "w") do |file|
    file.puts Digest::SHA256.file(t.prerequisites.first).hexdigest
  end
end

task "tgz:build" => pkg("lunchy-#{version}.tgz")
task "tgz:sign"  => pkg("lunchy-#{version}.tgz.sha256")

def tgz_signature
  File.read(pkg("lunchy-#{version}.tgz.sha256")).chomp
end

task "tgz:clean" do
  clean pkg("lunchy-#{version}.tgz")
end

task "tgz:release" => %w( tgz:build tgz:sign ) do |t|
  store pkg("lunchy-#{version}.tgz"), "lunchy/lunchy-#{version}.tgz"
  store pkg("lunchy-#{version}.tgz"), "lunchy/lunchy.tgz"
end
