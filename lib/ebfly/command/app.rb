module Ebfly
  class App < Thor
    include Command

    desc "create <name>", "Create an application named <name>"
    option :d, :banner => "<description>", :desc => "Describes the application"
    def create(name)
      puts "Create app: #{name} ..."
      opts = { application_name: name }
      opts.merge!(description: options[:d]) if options[:d]

      debug(opts)
      ret = run { eb.create_application(opts) }
      debug(ret)
      show_app_info(ret[:application])
    end

    desc "delete <name>", "Delete an application named <name>"
    option :f, :desc => "Terminate running environment by force", :default => false, :type => :boolean
    def delete(name)
      puts "Delete app: #{name} ..."
      opts = {
        application_name: name,
        terminate_env_by_force: options[:f]
      } 
      debug(opts)
      run { eb.delete_application(opts) }
      puts "Done"
    end

    desc "info <name>", "Show information of the application"
    def info(name)
      begin
        inf = app_info(name)
        debug inf
        show_app_info(inf)
      rescue => err
        style_err err
        exit 1
      end
    end

    private

    def app_info(app)
      opts = {
        application_names: [ app ]
      }
      ret = run { eb.describe_applications(opts) }
      raise "application named #{app} not found" unless ret[:applications][0]
      ret[:applications][0]
    end

    def show_app_info(app)
      puts ""
      puts "=== application info ==="
      puts "application name:\t#{app[:application_name]}"
      puts "description:\t\t#{app[:description]}"
      puts "created at:\t\t#{app[:date_created]}"
      puts "updated at:\t\tapplication name: #{app[:date_updated]}"
      puts "versions:\t\t#{app[:versions]}"
      puts "configuration_templates:#{app[:configuration_templates]}"
    end
  end
end
