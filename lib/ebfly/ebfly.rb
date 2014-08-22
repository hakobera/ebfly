require "thor"
require "aws-sdk"
require "pp"
require "open3"

module Ebfly
  module Command
    PREDEFINED_SOLUTION_STACKS = {
      "php54"    => "64bit Amazon Linux 2014.03 v1.0.4 running PHP 5.4",
      "php55"    => "64bit Amazon Linux 2014.03 v1.0.4 running PHP 5.5",
      "nodejs"   => "64bit Amazon Linux 2014.03 v1.0.4 running Node.js",
      "python26" => "64bit Amazon Linux 2014.03 v1.0.4 running Python",
      "python27" => "64bit Amazon Linux 2014.03 v1.0.4 running Python 2.7",
      "ruby19"   => "64bit Amazon Linux 2014.03 v1.0.4 running Ruby 1.9.3",
      "ruby20"   => "64bit Amazon Linux 2014.03 v1.0.4 running Ruby 2.0 (Passenger Standalone)",
      "ruby20-puma" => "64bit Amazon Linux 2014.03 v1.0.5 running Ruby 2.0 (Puma)",
      "ruby21"   => "64bit Amazon Linux 2014.03 v1.0.0 running Ruby 2.1 (Passenger Standalone)",
      "ruby21-puma" => "64bit Amazon Linux 2014.03 v1.0.0 running Ruby 2.1 (Puma)",
      "docker0.9" => "64bit Amazon Linux 2014.03 v1.0.5 running Docker 0.9.0",
      "docker09" => "64bit Amazon Linux 2014.03 v1.0.5 running Docker 0.9.0",
      "docker10" => "64bit Amazon Linux 2014.03 v1.0.1 running Docker 1.0.0"
    }

    SUPPORTED_SOLUTION_STACKS = ['Docker', 'Node.js', 'PHP', 'Python', 'Ruby']

    def eb
      @eb ||= AWS::ElasticBeanstalk.new
      @eb.client
    end

    def s3
      @s3 ||= AWS::S3.new
    end

    def run(&block)
      begin
        res = yield
        raise res.error unless res.successful?
        res
      rescue => err
        style_err(err)
        exit 1
      end
    end

    def s3_bucket
      @s3_bucket ||= (run { eb.create_storage_location }[:s3_bucket])
    end

    def style_err(err)
      puts "ERR! #{err.message}" 
    end

    def debug(obj)
      pp obj if ENV["DEBUG"]
    end

    def exist_command?(cmd)
      exts = ENV['PATHEXT'] ? ENV['PATHEXT'].split(';') : ['']
      ENV['PATH'].split(File::PATH_SEPARATOR).each do |path|
      exts.each { |ext|
        exe = File.join(path, "#{cmd}#{ext}")
        return exe if File.executable? exe
      }
      end
      return nil
    end

    def env_name(app, env)
      "#{app}-#{env}"
    end

    def tier(type)
      if type == "web"
        return { name: "WebServer", type: "Standard", version: "1.0" }
      elsif type == "worker"
        return { name: "Worker", type: "SQS/HTTP", version: "1.1" }
      elsif type == "worker1.0"
        return { name: "Worker", type: "SQS/HTTP", version: "1.0" }
      else
        raise "Environment tier definition not found"
      end
    end

    def solution_stack(name)
      return PREDEFINED_SOLUTION_STACKS[name] if PREDEFINED_SOLUTION_STACKS.key?(name)
      return name
    end
  end
end
