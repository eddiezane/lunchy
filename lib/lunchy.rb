class Lunchy
  VERSION = '0.1.1'

  def start(params)
    raise ArgumentError, "start [name]" if params.empty?
    name = params[0]
    files = plists.select {|k,v| k =~ /#{name}/i }
    if files.length > 1
      return puts "Multiple daemons found matching '#{name}'. You need to be more specific. Matches found are:\n" + files.keys.join("\n")
    elsif files.length == 0
      return puts "No daemon found matching '#{name}'" if !name
    else
      execute("launchctl load #{files.values.first.inspect}")
    end
  end

  def stop(params)
    raise ArgumentError, "stop [name]" if params.empty?
    name = params[0]
    files = plists.select {|k,v| k =~ /#{name}/i }
    if files.length > 1
      return puts "Multiple daemons found matching '#{name}'. You need to be more specific. Matches found are:\n" + files.keys.join("\n")
    elsif files.length == 0
      return puts "No daemon found matching '#{name}'" if !name
    else
      execute("launchctl unload #{files.values.first.inspect}")
    end
  end

  def restart(params)
    stop(params)
    start(params)
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
  
  private

  def execute(cmd)
    puts "Executing: #{cmd}" if verbose?
    puts `#{cmd}`
  end

  def plists
    @plists ||= begin
      plists = {}
      %w(/Library/LaunchAgents ~/Library/LaunchAgents).each do |dir|
        Dir["#{File.expand_path(dir)}/*.plist"].each do |filename|
          plists[File.basename(filename, ".plist")] = filename
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