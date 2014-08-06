task "brew:release" => pkg("lunchy-#{version}.tgz.sha256") do |t|
  sha256 = File.read(t.prerequisites[0]).strip
  tempdir do |dir|
    dest = 'homebrew-lunchy'
    cd = "cd #{dest}"

    sh "git clone git@github.com:merqlove/homebrew-lunchy.git #{dest}"
    formula = File.read('homebrew-lunchy/lunchy.rb')
    release = formula.gsub(/(url.+)-([0-9.-_]+)(\.tgz)/, "\\1-#{version}.tgz")
              .gsub(/(sha256\s).*/, "\\1'#{sha256}'")
    File.open("#{dest}/lunchy.rb", 'w') do |f|
      f.write release
    end

    begin
      # Push into repo
      sh "#{cd} && git add ."
      sh "#{cd} && git commit -m 'Version bump'"
      sh "#{cd} && git tag v#{version}"
      sh "#{cd} && git push origin master --tags"
    rescue
      nil
    end
  end
end
