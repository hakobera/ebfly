class Ebifly::CLI

  def self.start(*args)
    begin
      puts "success"
      exit(0)
    rescue => error
      puts error.message
      exit(1)
    end
  end

end
