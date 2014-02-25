require "thor"
require "aws-sdk"

require_relative 'ebfly'
require_relative 'version'
require_relative 'command/app'
require_relative 'command/env'
require_relative 'command/config'

module Ebfly
  class CLI < Thor
    desc "version", "show version"
    def version
      puts "Ebfly #{Ebfly::VERSION}"
    end

    desc "app SUBCOMMAND ...ARGS", "manage application"
    subcommand "app", App

    desc "env SUBCOMMAND ...ARGS -a APP", "manager environment"
    subcommand "env", Environment

    desc "config SUBCOMMAND ...ARGS -a APP", "manager environment's config vars"
    subcommand "config", Config
  end
end
