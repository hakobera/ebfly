module Ebfly
  class Config < Thor
    include Command

    desc "show", "Show config vars of the specified environment"
    option :a, :required => true, :banner => "<app>", :desc => "Application name"
    option :e, :required => true, :banner => "<env>", :desc => "Environment name"
    def show
      app = options[:a]
      env = options[:e]

      configs = get_env_conf(app, env)
      show_env_conf(app, env, configs)
    end

    desc "add", "Add config vars to the specified environment"
    option :a, :required => true, :banner => "<app>", :desc => "Application name"
    option :e, :required => true, :banner => "<env>", :desc => "Environment name"
    option :c, :required => true, :banner => "<key1=value1 key2=value2 ...>", :type => :array, :desc => "Config vars"
    def add
      ret = add_environment_config(options[:a], options[:e], options[:c])
      debug(ret)
    end

    desc "rm", "Remove config vars of the specified environment"
    option :a, :required => true, :banner => "<app>", :desc => "Application name"
    option :e, :required => true, :banner => "<env>", :desc => "Environment name"
    option :c, :required => true, :banner => "<key1 key2 ...>", :type => :array, :desc => "Config vars"
    def rm
      ret = remove_environment_config(options[:a], options[:e], options[:c])
      debug(ret)
    end

    desc "copy", "Copy all config vars to the specified environment from another environment"
    option :a, :required => true, :banner => "<app>", :desc => "Application name"
    option :e, :required => true, :banner => "<dest-env>", :desc => "Destination environment name"
    option :s, :required => true, :banner => "<src-env>", :desc => "Source environment name"
    def copy
      app = options[:a]
      env = options[:e]
      src = options[:s]

      puts ""
      puts "=== Before ==="
      config_vars = get_env_conf(app, env)
      show_env_conf(app, env, config_vars)

      src_config_vars = get_env_conf(app, src)
      add_environment_config(app, env, src_config_vars)

      puts ""
      puts "=== After ==="
      config_vars = get_env_conf(app, env)    
      show_env_conf(app, env, config_vars)
    end

    private

    def add_environment_config(app, env, config_vars)
      puts ""
      puts "Add config vars: #{env_name(app, env)}"

      settings = []
      config_vars.each do |config_var|
        k, v = config_var.split("=")
        next if v.nil?
        conf = {
          namespace: "aws:elasticbeanstalk:application:environment",
          option_name: k.strip,
          value: v.strip
        }
        settings << conf
      end

      opts = {
        environment_name: env_name(app, env),
        option_settings: settings
      }
      run { eb.update_environment(opts) }
    end

    def remove_environment_config(app, env, keys)
      puts ""
      puts "Remove config vars: #{env_name(app, env)}"

      settings = []
      keys.each do |key|
        conf = {
          namespace: "aws:elasticbeanstalk:application:environment",
          option_name: key.strip,
        }
        settings << conf
      end

      opts = {
        environment_name: env_name(app, env),
        options_to_remove: settings
      }
      run { eb.update_environment(opts) }
    end

    def get_env_conf(app, env)
      opts = {
        application_name: app,
        environment_name: env_name(app, env)
      }

      ret = run { eb.describe_configuration_settings(opts) }
      debug(ret)

      config_vars = []
      settings = ret[:configuration_settings]
      settings.each do |setting|
        opts = setting[:option_settings]
        opts.each do |opt|
          next unless opt[:option_name] == "EnvironmentVariables"
          config_vars = opt[:value].split(",")
        end
      end

      config_vars.sort!
    end

    def show_env_conf(app, env, config_vars)
      puts ""
      puts "=== #{env_name(app, env)} Config Vars ==="
      config_vars.each do |config_var|
        puts config_var
      end
    end
  end
end
