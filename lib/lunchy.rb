require 'fileutils'

class Lunchy
  VERSION = '0.3.0'

  def start(params)
    raise ArgumentError, "start [-w] [name]" if params.empty?
    name = params[0]
    files = plists.select {|k,v| k =~ /#{name}/i }
    files = Hash[files] if files.is_a?(Array) # ruby 1.8
    if files.size > 1
      return puts "Multiple daemons found matching '#{name}'. You need to be more specific. Matches found are:\n" + files.keys.join("\n")
    elsif files.size == 0
      return puts "No daemon found matching '#{name}'" if !name
    else
      execute("launchctl load #{CONFIG[:write] ? '-w ' : ''}#{files.values.first.inspect}")
    end
  end

  def stop(params)
    raise ArgumentError, "stop [-w] [name]" if params.empty?
    name = params[0]
    files = plists.select {|k,v| k =~ /#{name}/i }
    files = Hash[files] if files.is_a?(Array) # ruby 1.8
    if files.size > 1
      return puts "Multiple daemons found matching '#{name}'. You need to be more specific. Matches found are:\n" + files.keys.join("\n")
    elsif files.size == 0
      return puts "No daemon found matching '#{name}'" if !name
    else
      execute("launchctl unload #{CONFIG[:write] ? '-w ' : ''}#{files.values.first.inspect}")
    end
  end

  def restart(params)
    stop(params.dup)
    start(params.dup)
  end

  def status(params)
    pattern = params[0]
    cmd = "launchctl list"
    if !verbose?
      agents = "(" + plists.keys.join("|") + ")"
      cmd << " | grep -i -E \"#{agents}\""
    end
    cmd << " | grep -i \"#{pattern}\"" if pattern
    execute(cmd)
  end

  def ls(params)
    agents = plists.keys
    agents = agents.grep(/#{params[0]}/) if !params.empty?
    puts agents.sort.join("\n")
  end
  alias_method :list, :ls

  def install(params)
    raise ArgumentError, "install [file]" if params.empty?
    filename = params[0]
    %w(~/Library/LaunchAgents /Library/LaunchAgents).each do |dir|
      if File.exist?(File.expand_path(dir))
        FileUtils.cp filename, File.join(File.expand_path(dir), File.basename(filename))
        return puts "#{filename} installed to #{dir}"
      end
    end
  end

  private

  def execute(cmd)
    puts "Executing: #{cmd}" if verbose?
    puts `#{cmd}`
  end

  def plists
    @plists ||= begin
      plists = {}
      %w(/Library/LaunchAgents ~/Library/LaunchAgents).each do |dir|
        Dir["#{File.expand_path(dir)}/*.plist"].inject(plists) do |memo, filename|
          memo[File.basename(filename, ".plist")] = filename; memo
        end
      end
      plists
    end
  end

  # def daemons
  #   @daemons ||= begin
  #     content = `launchctl list | grep -v -i "^-\\|anonymous"`
  #     daemons = []
  #     content.each_line do |x|
  #       data = x.split(' ')
  #       daemons << {
  #         :pid => data[0].to_i,
  #         :name => data[2]
  #       }
  #     end
  #   end
  # end

  def verbose?
    CONFIG[:verbose]
  end
end