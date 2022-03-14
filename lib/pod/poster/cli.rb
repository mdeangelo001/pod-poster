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
    end
  end
end
