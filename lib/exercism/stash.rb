class Exercism
  class Stash

  	attr_reader :code, :filename

  	def self.save(body)
  	  new(body).save
  	end

  	def initialize(body)
  	  @code = body['code']
      @filename = body['filename']
  	end

  	def save
  	  File.open path, 'w' do |f|
  	  	f.write code
  	  end
  	  self
  	end

    private

  	def path
  	  File.join(FileUtils.pwd, filename)
  	end
  end
end