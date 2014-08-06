require "bundler/gem_tasks"

require 'rubygems'

PROJECT_ROOT = File.expand_path('..', __FILE__)
$LOAD_PATH.unshift "#{PROJECT_ROOT}/lib"

require 'lunchy'

# Used part of Heroku script https://github.com/heroku/heroku
#
require 'erb'
require 'fileutils'
require 'tmpdir'

def assemble(source, target, perms = 0644)
  FileUtils.mkdir_p(File.dirname(target))
  File.open(target, 'w') do |f|
    f.puts ERB.new(File.read(source)).result(binding)
  end
  File.chmod(perms, target)
end

def assemble_distribution(target_dir = Dir.pwd)
  distribution_files.each do |source|
    target = source.gsub(/^#{project_root}/, target_dir)
    FileUtils.mkdir_p(File.dirname(target))
    FileUtils.cp(source, target)
  end
end

GEM_BLACKLIST = %w( bundler lunchy )

def assemble_gems(target_dir = Dir.pwd)
  lines = `cd #{project_root} && bundle show `.strip.split("\n")
  fail 'error running bundler' unless $?.success? # rubocop:disable Style/SpecialGlobalVars
  gems = `cd #{project_root} && export BUNDLE_WITHOUT=development && bundle show `.split("\n")
  gems.each do |line|
    next unless line =~ /^  \* (.*?) \((.*?)\)/
    next if GEM_BLACKLIST.include?(Regexp.last_match[1])
    puts "vendoring: #{Regexp.last_match[1]}-#{Regexp.last_match[2]}"
    gem_dir = ` cd #{project_root} && bundle show #{Regexp.last_match[1]} `.strip
    FileUtils.mkdir_p "#{target_dir}/vendor/gems"
    ` cp -R "#{gem_dir}" "#{target_dir}/vendor/gems" `
  end.compact
end

def clean(file)
  rm file if File.exist?(file)
end

def distribution_files(type = nil)
  Dir[File.expand_path("#{PROJECT_ROOT}/{bin,lib}/**/*", __FILE__)].select do |file|
    File.file?(file)
  end
end

def mkchdir(dir)
  FileUtils.mkdir_p(dir)
  Dir.chdir(dir) do |dir|
    yield(File.expand_path(dir))
  end
end

def pkg(filename)
  FileUtils.mkdir_p('pkg')
  File.expand_path("../pkg/#{filename}", __FILE__)
end

def project_root
  File.dirname(__FILE__)
end

def resource(name)
  File.expand_path("../dist/resources/#{name}", __FILE__)
end

def s3_connect
  return if @s3

  require 's3'

  unless ENV['AWS_ACCESS_KEY_ID'] && ENV['AWS_SECRET_ACCESS_KEY']
    puts 'please set AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY in your environment'
    exit 1
  end

  @s3 = S3::Service.new(
    access_key_id: ENV['AWS_ACCESS_KEY_ID'],
    secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
  )
end

def store(package_file, filename, bucket = 'assets.merqlove.ru')
  s3_connect
  puts "storing: #{filename}"
  release = @s3.bucket(bucket).objects.build(filename)
  release.content = File.read(package_file)
  release.save
end

def tempdir
  Dir.mktmpdir do |dir|
    Dir.chdir(dir) do
      yield(dir)
    end
  end
end

def version
  Lunchy::VERSION
end

Dir[File.expand_path('../dist/**/*.rake', __FILE__)].each do |rake|
  import rake
end

desc 'Release the latest version'
task 'release' => %w(tgz:release brew:release manifest:update) do
  puts("Released v#{version}")
end
