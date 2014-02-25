require "thor"
require "aws-sdk"
require "pp"
require "open3"

module Ebfly
  module Command
    def eb
      @eb ||= AWS::ElasticBeanstalk.new
      @eb.client
    end

    def run(&block)
      begin
        yield
      rescue => err
        style_err(err)
        exit 1
      end
    end

    def style_err(err)
      puts "ERR! #{err.message}" 
    end

    def debug(obj)
      pp obj if ENV["DEBUG"]
    end

    def exist_command?(cmd)
      Open3.capture3("type", cmd)[2].exitstatus == 0 rescue nil
    end
  end
end
