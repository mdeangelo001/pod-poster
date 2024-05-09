# frozen_string_literal: true

require 'forwardable'
require 'httparty'
require 'feedjira'
require 'nokogiri'

module Pod
  module Poster
    class Command
      extend Forwardable

      def_delegators :command, :run

      def get_feed(url)
        HTTParty.get(url).body
      end

      def parse_feed_entries(xml)
        Feedjira.parse(xml).entries.map { |e| e.to_h }
      end

      def trim_feed!(entries)
        entries.map! { |e| e.select{|k,v| ['title', 'summary', 'published', 'url'].include?(k) } }
      end

      def sort_feed!(entries)
        entries.sort! { |x,y| x['published'] <=> y['published'] }
      end

      # The summary is wrapped in <div> tags that need to be removed.
      def parse_feed_entry!(entry)
        doc = Nokogiri::HTML(entry['summary'])
        entry['summary'] = doc.text
        entry
      end

      # Execute this command
      #
      # @api public
      def execute(*)
        raise(
          NotImplementedError,
          "#{self.class}##{__method__} must be implemented"
        )
      end

      # The external commands runner
      #
      # @see http://www.rubydoc.info/gems/tty-command
      #
      # @api public
      def command(**options)
        require 'tty-command'
        TTY::Command.new(options)
      end

      # The cursor movement
      #
      # @see http://www.rubydoc.info/gems/tty-cursor
      #
      # @api public
      def cursor
        require 'tty-cursor'
        TTY::Cursor
      end

      # Open a file or text in the user's preferred editor
      #
      # @see http://www.rubydoc.info/gems/tty-editor
      #
      # @api public
      def editor
        require 'tty-editor'
        TTY::Editor
      end

      # File manipulation utility methods
      #
      # @see http://www.rubydoc.info/gems/tty-file
      #
      # @api public
      def generator
        require 'tty-file'
        TTY::File
      end

      # Terminal output paging
      #
      # @see http://www.rubydoc.info/gems/tty-pager
      #
      # @api public
      def pager(**options)
        require 'tty-pager'
        TTY::Pager.new(options)
      end

      # Terminal platform and OS properties
      #
      # @see http://www.rubydoc.info/gems/tty-pager
      #
      # @api public
      def platform
        require 'tty-platform'
        TTY::Platform.new
      end

      # The interactive prompt
      #
      # @see http://www.rubydoc.info/gems/tty-prompt
      #
      # @api public
      def prompt(**options)
        require 'tty-prompt'
        TTY::Prompt.new(options)
      end

      # Get terminal screen properties
      #
      # @see http://www.rubydoc.info/gems/tty-screen
      #
      # @api public
      def screen
        require 'tty-screen'
        TTY::Screen
      end

      # The unix which utility
      #
      # @see http://www.rubydoc.info/gems/tty-which
      #
      # @api public
      def which(*args)
        require 'tty-which'
        TTY::Which.which(*args)
      end

      # Check if executable exists
      #
      # @see http://www.rubydoc.info/gems/tty-which
      #
      # @api public
      def exec_exist?(*args)
        require 'tty-which'
        TTY::Which.exist?(*args)
      end
    end
  end
end
