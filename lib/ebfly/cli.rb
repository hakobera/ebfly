require "thor"
require "aws-sdk"

module Ebfly

  module ElasticBeanstalk
    def eb
      @eb ||= AWS::ElasticBeanstalk.new
      @eb.client
    end

    def run(&block)
      begin
        yield
        puts "Done."
      rescue => err
        style_err(err)
        exit 1
      end
    end

    def style_err(err)
      puts "ERR! #{err.message}" 
    end
  end

  class App < Thor
    include ElasticBeanstalk

    desc "Create app: <name>", "Create an application named <name>"
    option :d, :banner => "<description>", :desc => "Describes the application"
    def create(name)
      puts "Create app: #{name} ..."
      opts = { application_name: name }
      opts.meage!(description: options[:description]) if options[:description]
      run { eb.create_application(opts) }
    end

    desc "Delete app: <name>", "Delete an application named <name>"
    option :force, :desc => "Terminate running environment by force", :default => false, :type => :boolean
    def delete(name)
      puts "Delete app: #{name} ..."
      opts = { application_name: name }
      opts.merge!(terminate_env_by_force: true) if options[:force]
      run { eb.delete_application(opts) }
    end
  end

  class CLI < Thor
    include ElasticBeanstalk

    desc "app SUBCOMMAND ...ARGS", "manage application"
    subcommand "app", App
  end

end
