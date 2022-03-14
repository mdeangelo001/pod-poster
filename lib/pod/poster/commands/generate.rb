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

          @default_url = 'https://www.omnibusproject.com/rss'

          xml = get_feed(@default_url)
          entries = parse_feed_entries(xml)
          trim_feed!(entries)
          sort_feed!(entries)
          entry = entries.last

          md = /Entry \d{1,}\.(\d*[a-zA-Z]{2})(\d{1,})(\d{2})/.match entry['title']
          verse_ref = "Not found for {md[1]}+#{md[2]}:#{md[3]}"
          if md
            bible_verse = HTTParty.get("https://bible-api.com/#{md[1]}+#{md[2]}:#{md[3]}").body
            bible_verse_data = JSON.parse(bible_verse,{:symbolize_names => true})
            verse_ref = "#{bible_verse_data[:text].strip} - #{bible_verse_data[:reference]}"
          end

          md = /Certificate #(\d{1,})/.match entry['summary']
          movie_ref = "Not Found for #{md[1]}"
          if md
            html = HTTParty.get("https://www.filmsonsuper8.com/censorship/mpaa-film-numbers-52000.html").body
            document = Nokogiri::HTML.parse(html)
            result = (document.xpath "//table/tr[./td[text()='#{md[1]}']]/td")
            movie_ref = "#{result[2].text} (#{result[0].text})" unless result.empty?
          end

          doc = <<~EOF
          ## #{entry['title']}

          The latest entry has entered the vault i#{entry['summary'][1..].strip}

          > #{verse_ref}

          Related Movie: #{movie_ref}

          *You can support the important work of The Omnibus Project here
          [https://www.patreon.com/omnibusproject/](https://www.patreon.com/omnibusproject/)
          and find merch at
          [https://www.omnibusproject.com/store](https://www.omnibusproject.com/store)*
          EOF

          output.puts doc
        end
      end
    end
  end
end
