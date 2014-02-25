require "thor"
require "aws-sdk"

require_relative 'ebfly'
require_relative 'command/app'
require_relative 'command/env'

module Ebfly
  class CLI < Thor
    desc "app SUBCOMMAND ...ARGS", "manage application"
    subcommand "app", App

    desc "env SUBCOMMAND ...ARGS -a APP", "manager environment"
    subcommand "env", Environment
  end
end
