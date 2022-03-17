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

          verse_ref = nil
          md = /Entry \d{1,}\.(\d*[a-zA-Z]{1,2})(\d{1,})(\d{2})/.match entry['title']
          if md
            book = md[1]
            chapter = md[2]
            verse = md[3]
            book =
              case book
                when '1S'
                  '1Samuel'
                when '2S'
                  '2Samuel'
                when '1R'
                  '1Kings'
                when '2R'
                  '2Kings'
                when '1K'
                  '1Corinthians'
                when '2K'
                  '2Corinthians'
                when '1T'
                  '1Timothy'
                when '2T'
                  '2Timothy'
                when '1P'
                  '1Peter'
                when '2P'
                  '2Peter'
                when '1J'
                  '1John'
                when '2J'
                  '2John'
                when '3J'
                  '3John'
                when '1M'
                  '1Maccabees'
                when '2M'
                  '2Maccabees'
                when '3M'
                  '3Maccabees'
                when '4M'
                  '4Maccabees'
                else
                  book
              end

            verse_ref = "Not found for https://bible-api.com/#{book}+#{chapter}:#{verse}" 
            bible_verse = HTTParty.get("https://bible-api.com/#{book}+#{chapter}:#{verse}").body
            bible_verse_data = JSON.parse(bible_verse,{:symbolize_names => true})
            if bible_verse_data[:reference]
              verse_ref = "#{bible_verse_data[:text].strip} - #{bible_verse_data[:reference]}"
            end
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
          #{entry['url']}
          #{entry['title']}

          The latest entry has entered the vault i#{entry['summary'][1..].strip}

          #{verse_ref}

          Related Movie: #{movie_ref}

          You can support the important work of The Omnibus Project here \
          https://www.patreon.com/omnibusproject/ and find merch at \
          https://www.omnibusproject.com/store
          EOF

          output.puts doc
        end
      end
    end
  end
end
