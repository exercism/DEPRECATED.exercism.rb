class Exercism
  class Stash

  	attr_reader :stash_file

  	def self.save(body)
  	  new(body).save
  	end

  	def initialize(body)
  	  @stash_file = body['code']
  	end

  	def save
  	  File.open path, 'w' do |f|
  	  	f.write code
  	  end
  	  self
  	end

  	def path
  	  File.join(FileUtils.pwd, name)
  	end

  	def name
  	  @stash_file.partition(' ')[0]
  	end

  	def code
  	  @stash_file.partition(' ')[2]
  	end

  end
end