require 'fileutils'

class Lunchy
  VERSION = '0.10.1'

  def start(params)
    raise ArgumentError, "start [-wF] [name]" if params.empty?

    with_match params[0] do |name, path|
      execute("launchctl load #{force}#{write}#{path.inspect}")
      puts "started #{name}"
    end
  end

  def stop(params)
    raise ArgumentError, "stop [-w] [name]" if params.empty?

    with_match params[0] do |name, path|
      execute("launchctl unload #{write}#{path.inspect}")
      puts "stopped #{name}"
    end
  end

  def restart(params)
    stop(params.dup)
    start(params.dup)
  end

  def status(params)
    pattern = pattern_for_grep params[0]
    cmd = "launchctl list"
    unless verbose?
      agents = plists.keys.map { |k| "-e \"#{k}\"" }.join(" ")
      cmd << " | grep -i #{agents}"
    end

    cmd.gsub!('.','\.')
    cmd << " | grep -i \"#{pattern}\"" if pattern
    execute(cmd)
  end

  def ls(params)
    pattern = pattern_regex params[0]
    agents = plists.keys
    agents = agents.grep(pattern) if !params.empty?
    if long
      puts agents.map { |agent| plists[agent] }.sort.join("\n")
    else
      puts agents.sort.join("\n")
    end
  end
  alias_method :list, :ls

  def install(params)
    raise ArgumentError, "install [-s] [file]" if params.empty?
    filename = params[0]
    %w(~/Library/LaunchAgents /Library/LaunchAgents).each do |dir|
      if File.exist?(File.expand_path(dir))
        if symlink
          FileUtils.ln_s filename, File.join(File.expand_path(dir), File.basename(filename)), force: true
          return puts "#{filename} installed to #{dir}"
        else
          FileUtils.cp filename, File.join(File.expand_path(dir), File.basename(filename))
          return puts "#{filename} installed to #{dir}"
        end
      end
    end
  end

  def uninstall(params)
    raise ArgumentError, "uninstall [name]" if params.empty?

    stop(params.dup)

    with_match params[0] do |name, path|
      if File.exist?(path)
        FileUtils.rm(path)
        puts "uninstalled #{name}"
      end
    end
  end
  alias_method :rm, :uninstall

  def show(params)
    raise ArgumentError, "show [name]" if params.empty?

    with_match params[0] do |_, path|
      puts IO.read(path)
    end
  end

  def edit(params)
    raise ArgumentError, "edit [name]" if params.empty?

    with_match params[0] do |_, path|
      editor = ENV['EDITOR']
      if editor.nil?
        raise 'EDITOR environment variable is not set'
      else
        execute("#{editor} #{path.inspect} > `tty`")
      end
    end
  end

  private

  def exact
    CONFIG[:exact]
  end

  def force
    CONFIG[:force] and '-F '
  end

  def write
    CONFIG[:write] and '-w '
  end

  def long
    CONFIG[:long]
  end

  def symlink
    CONFIG[:symlink]
  end

  def pattern_for_grep(s)
    exact ? "\\b#{s}\\b" : s if s
  end

  def pattern_regex(s)
    /#{pattern_for_grep(s)}/i
  end

  def with_match(name)
    files = plists.select {|k,_| k =~ pattern_regex(name) }
    files = Hash[files] if files.is_a?(Array) # ruby 1.8

    if files.size > 1
      puts "Multiple daemons found matching '#{name}'. You need to be more specific. Matches found are:\n#{files.keys.join("\n")}"
    elsif files.empty?
      puts "No daemon found matching '#{name}' #{exact ? 'exactly' : nil}" if name
    else
      yield(*files.to_a.first)
    end
  end

  def execute(cmd)
    puts "Executing: #{cmd}" if verbose?
    emitted = `#{cmd}`
    puts emitted unless emitted.empty?
  end

  def plists
    @plists ||= begin
      plists = {}
      dirs.each do |dir|
        Dir["#{File.expand_path(dir)}/*.plist"].inject(plists) do |memo, filename|
          memo[File.basename(filename, ".plist")] = filename; memo
        end
      end
      plists
    end
  end

  def dirs
    result = %w(/Library/LaunchAgents ~/Library/LaunchAgents)
    result.push('/Library/LaunchDaemons', '/System/Library/LaunchDaemons') if root?
    result
  end

  def root?
    Process.euid == 0
  end

  def verbose?
    CONFIG[:verbose]
  end
end
