# frozen_string_literal: true

require 'thor'

module Pod
  module Poster
    # Handle the application command line parsing
    # and the dispatch to various command objects
    #
    # @api public
    class CLI < Thor
      # Error raised by this runner
      Error = Class.new(StandardError)

      desc 'version', 'pod-poster version'
      def version
        require_relative 'version'
        puts "v#{Pod::Poster::VERSION}"
      end
      map %w(--version -v) => :version

      desc 'generate [CONFIG_NAME]', 'Command description...'
      method_option :help, aliases: '-h', type: :boolean,
                           desc: 'Display usage information'
      method_option :episode, type: :numeric, default: -1,
        desc: 'Episode to fetch: 1 for first, -1 for most recent'
      def generate(configName = nil)
        if options[:help]
          invoke :help, ['generate']
        else
          require_relative 'commands/generate'
          Pod::Poster::Commands::Generate.new(configName, options).execute
        end
      end
    end
  end
end
