module Ebfly
  class Environment < Thor
    include Command
    include Options

    desc "create <name>", "Create an environment named <name>"
    option :a, :required => true, :banner => "<app>", :desc => "Application name"
    option :s, :required => true, :banner => "<stack>", :desc => "The Solution stack name"
    option :t, :banner => "<tier>", :default => "web", :desc => "Tier type (web|worker|worker1.0)"
    option :d, :banner => "<description>", :desc => "Describes the environment"
    option :l, :banner => "<label>", :desc => "The name of the application version to deploy"
    option :o, :banner => "<namespace-key=value ...>", :type => :array, :desc => "ElasticBeanstalk option values. See http://docs.aws.amazon.com/elasticbeanstalk/latest/dg/command-options.html"
    def create(name)
      app = options[:a]
      puts "Create environment: #{env_name(app, name)} ..."
      opts = {
        application_name: app,
        environment_name: env_name(app, name),
        solution_stack_name: solution_stack(options[:s]),
        tier: tier(options[:t])
      }
      opts.merge!(description: options[:d]) if options[:d]
      opts.merge!(version_label: options[:l]) if options[:l]
      opts.merge!(option_settings: parse_option_values(options[:o])) if options[:o] and !options[:o].empty?
      
      debug opts
      ret = run { eb.create_environment(opts) }
      show_env_info(ret)
    end

    desc "delete <name>", "Delete the specified environment"
    option :a, :required => true, :banner => "<app>", :desc => "Application name"
    def delete(name)
      app = options[:a]
      puts "Delete environment: #{env_name(app, name)} ..."
      opts = {
        environment_name: env_name(app, name)
      }
      run { eb.terminate_environment(opts) }
      puts "Done"
    end

    desc "update <name>", "Update the specified environment"
    option :a, :required => true, :banner => "<app>", :desc => "Application name"
    option :d, :banner => "<description>", :desc => "Describes the environment"
    option :l, :banner => "<label>", :desc => "The name of the application version to deploy"
    option :o, :banner => "<namespace-key=value ...>", :type => :array, :desc => "ElasticBeanstalk option values. See http://docs.aws.amazon.com/elasticbeanstalk/latest/dg/command-options.html"
    def update(name)
      app = options[:a]
      puts "Update environment: #{env_name(app, name)} ..."
      opts = {
        environment_name: env_name(app, name)
      }
      opts.merge!(description: options[:d]) if options[:d]
      opts.merge!(version_label: options[:l]) if options[:l]
      opts.merge!(option_settings: parse_option_values(options[:o])) if options[:o] and !options[:o].empty?

      debug(opts)
      ret = run { eb.update_environment(opts) }
      show_env_info(ret)
    end

    desc "info <name>", "Show the specified environment information."
    option :a, :required => true, :banner => "<app>", :desc => "Application name"
    option :r, :default => false, :desc => "Show environment resources"
    def info(name)
      app = options[:a]
      begin 
        inf = env_info(app, name)
        debug inf
        show_env_info(inf)
      rescue => err
        style_err err
        exit 1
      end

      if options[:r]
        res = env_resources(app, name)      
        debug res
        show_env_resources(res)
      end
    end

    desc "open <name>", "Open environment CNAME in browser (Mac OS Only)"
    option :a, :required => true, :banner => "<app>", :desc => "Application name"
    def open(name)
      raise "This feature can run on Mac OS Only" unless exist_command?('open')

      inf = env_info(options[:a], name)
      url = "http://#{inf[:cname]}"
      system "open #{url}"
    end

    desc "push <name> <branch or tree_ish>", "Push and deploy the specified branch to the environment"
    option :a, :required => true, :banner => "<app>", :desc => "Application name"
    def push(name, branch)
      raise "git must be installed" unless exist_command?('git')
      app = options[:a]

      puts "push #{branch} to #{env_name(app, name)}"
      inf = env_info(app, name)
      show_env_info(inf)
      raise "Environment named #{env_name(app, name)} is in an invalid state for this operation. Must be Ready." if inf[:status] != "Ready"
      puts ""

      ish, e, s = Open3.capture3("git", "rev-parse", branch)
      ish.strip!
      time = Time.now.to_i
      version = "#{ish}-#{time}"
      file_name = "git-#{version}.zip"

      begin
        create_archive(file_name, ish)
        upload_archive(file_name)
        create_application_version(app, version, ish, file_name)
        ret = update_environment(app, name, version)
        debug(ret)
        show_env_info(ret)
      rescue => err
        style_err err
        exit 1
      ensure
        File.delete file_name if File.exist? file_name
      end
    end

    private

    def env_info(app, env)
      opts = {
        application_name: app,
        environment_names: [ env_name(app, env) ]
      }
      ret = run { eb.describe_environments(opts) }
      raise "Environment named #{env_name(app, env)} not found" unless ret[:environments][0]
      ret[:environments][0]
    end

    def env_resources(app, env)
      opts = {
        environment_name: env_name(app, env)
      }
      ret = run { eb.describe_environment_resources(opts) }
      ret[:environment_resources]
    end

    def create_archive(file_name, ish)
      puts "Create archive: #{file_name}"
      Open3.capture3("git", "archive", "--format", "zip", "--output", file_name, ish)
    end

    def upload_archive(file_name)
      puts "Upload archive #{file_name} to s3://#{s3_bucket}"
      bucket = s3.buckets[s3_bucket]
      obj = bucket.objects[file_name]
      obj.write(Pathname.new(file_name))
    end

    def create_application_version(app, version, ish, file_name)
      puts "Create application version: #{version}"
      opts = {
        application_name: app,
        version_label: version,
        description: ish,
        source_bundle: {
          s3_bucket: s3_bucket,
          s3_key: file_name
        }
      }
      run { eb.create_application_version(opts) }
    end

    def update_environment(app, env, version)
      puts "Update environment: #{env_name(app, env)} to #{version}"
      opts = {
        environment_name: env_name(app, env),
        version_label: version
      }
      run { eb.update_environment(opts) }
    end

    def show_env_info(res)
      puts ""
      puts "=== environment info ==="
      puts "application name:\t#{res[:application_name]}"
      puts "environment id:\t\t#{res[:environment_id]}"
      puts "environment name:\t#{res[:environment_name]}"
      puts "description:\t\t#{res[:description]}"
      puts "status:\t\t\t#{res[:status]}"
      puts "health:\t\t\t#{res[:health]}"
      puts "tier:\t\t\t#{res[:tier][:name]} #{res[:tier][:type]} #{res[:tier][:version]}"
      puts "solution stack name:\t#{res[:solution_stack_name]}"
      puts "endpoint url:\t\t#{res[:endpoint_url]}" if res[:endpoint_url]
      puts "cname:\t\t\t#{res[:cname]}" if res[:cname]
      puts "version label:\t\t#{res[:version_label]}" if res[:version_label]
      puts "updated at:\t\t#{res[:date_updated]}"
    end

    def show_env_resources(res)
      puts ""
      puts "=== environment resources ==="
      puts "auto scaling groups:\t#{res[:auto_scaling_groups]}"
      puts "instances:\t\t#{res[:instances]}"
      puts "launch configurations:\t#{res[:launch_configurations]}"
      puts "load balancers:\t\t#{res[:load_balancers]}"
      puts "triggers:\t\t#{res[:triggers]}"
      puts "queues:\t\t\t#{res[:queues]}"
    end
  end
end
