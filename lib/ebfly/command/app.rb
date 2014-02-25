module Ebfly
  class App < Thor
    include Command

    desc "Create app: <name>", "Create an application named <name>"
    option :d, :banner => "<description>", :desc => "Describes the application"
    def create(name)
      puts "Create app: #{name} ..."
      opts = { application_name: name }
      opts.merge!(description: options[:d]) if options[:d]
      ret = run { eb.create_application(opts) }
      pp ret
    end

    desc "Delete app: <name>", "Delete an application named <name>"
    option :f, :desc => "Terminate running environment by force", :default => false, :type => :boolean
    def delete(name)
      puts "Delete app: #{name} ..."
      opts = {
        application_name: name,
        terminate_env_by_force: options[:f]
      } 
      run { eb.delete_application(opts) }
    end
  end
end
