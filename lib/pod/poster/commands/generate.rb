# frozen_string_literal: true

require_relative '../command'

module Pod
  module Poster
    module Commands
      class Generate < Pod::Poster::Command
        def initialize(configName, options)
          @configName = configName
          @options = options
        end

        def execute(input: $stdin, output: $stdout)

          require_relative '../../../../plugins/omnibus'
          plugin = Pod::Poster::Plugins::Omnibus.new

          @default_url = 'https://www.omnibusproject.com/rss'
          #@default_url = 'https://audioboom.com/channels/5127257.rss'

          xml = get_feed(@default_url)
          entries = parse_feed_entries(xml)
          trim_feed!(entries)
          sort_feed!(entries)
          entry = entries[@options[:episode]]
          parse_feed_entry!(entry)

          output.puts plugin.generate entry
        end
      end
    end
  end
end
