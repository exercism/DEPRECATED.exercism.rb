class Stash < Thor

  desc "save FILE", "Stash code from a file in-progress"
  method_option :host, :aliases => '-h', :default => 'http://exercism.io', :desc => 'the url of the exercism application'
  def save(file)
    require 'exercism'

    begin
      puts file
      puts File.read file
      response = Exercism::Api.new(options[:host], Exercism.user).save_stash('user/assignments/stash', file)
      say "Stash file has been saved"
    rescue Exception => e
      puts "Error submitting stash"
      puts e.message
    end
  end

  desc "apply FILE", "Retrieve stashed file from exercism.io"
  method_option :host, :aliases => '-h', :default => 'http://exercism.io', :desc => 'the url of the exercism application'
  def apply(file)
    require 'exercism'

    begin
      stash = Exercism::Api.new(options[:host], Exercism.user).apply_stash('user/assignments/stash', file)
      if File.exists?(stash.filename)
        say "File: " + stash.filename + " already exists"
        if no?("Overwrite it? [y/n]")
          return
        end
      end
      stash.save
      puts "Stash file downloaded successfully: " + File.join(FileUtils.pwd, stash.filename)
    rescue Exception => e
      puts "Error: No stash file was found."
    end
  end

  desc "list", "List stashed files"
  method_option :host, :aliases => '-h', :default => 'http://exercism.io', :desc => 'the url of the exercism application'
  def list
    require 'exercism'
    begin
      stashed = Exercism::Api.new(options[:host], Exercism.user).list_stash('user/assignments/stash/list')
      stashed.each do |name|
        puts name
      end
    rescue Exception => e
      puts "Error: unable to retrieve stashed file list"
    end
  end

end