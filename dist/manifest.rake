task "manifest:update" do
  tempdir do |dir|
    File.open("VERSION", "w") do |file|
      file.puts version
    end
    puts "Current version: #{version}"
    store "#{dir}/VERSION", Lunchy::VERSION
  end
end