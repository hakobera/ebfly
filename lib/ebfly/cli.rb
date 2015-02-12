require "thor"
require "aws-sdk-v1"

require_relative 'ebfly'
require_relative 'version'
require_relative 'options'
require_relative 'command/app'
require_relative 'command/env'
require_relative 'command/config'
require_relative 'command/elasticbeanstalk'

module Ebfly
  class CLI < Thor
    desc "version", "show version"
    def version
      puts "Ebfly #{Ebfly::VERSION}"
    end

    desc "app SUBCOMMAND ...ARGS", "manage application"
    subcommand "app", App

    desc "env SUBCOMMAND ...ARGS", "manage environment"
    subcommand "env", Environment

    desc "config SUBCOMMAND ...ARGS", "manage environment's config vars"
    subcommand "config", Config

    desc "eb SUBCOMMAND ...ARGS", "Get information about ElasticBeanstalk"
    subcommand "eb", ElasticBeanstalk
  end
end
