# frozen_string_literal: true

require 'csv'

module Pod
  module Poster
    module Plugins
      class Omnibus

        def get_verse(title)
          verse_ref = nil
          md = /Entry \d{1,}\.(\w{2})(\d{1,})(\d{2})/.match title
          if md
            book = md[1]
            chapter = md[2]
            verse = md[3]
            book =
              case book
		when /G[EN]/
		  'Genesis'
		when 'EX'
		  'Exodus'
		when 'LV'
		  'Leviticus'
		when 'NU'
		  'Numbers'
		when 'DE'
		  'Deuteronomy'
		when 'JS'
		  'Joshua'
		when 'JG'
		  'Judges'
		when 'RU'
		  'Ruth'
		when '1S'
		  '1Samuel'
		when '2S'
		  '2Samuel'
		when '1K'
		  '1Kings'
		when '2K'
		  '2Kings'
		when '1CH'
		  '1Chronicles'
		when '2CH-'
		  '2Chronicles'
		when 'ER'
		  'Ezra'
		when 'NE'
		  'Nehemiah'
		when 'ES'
		  'Esther'
		when 'JB'
		  'Job'
		when 'PS'
		  'Psalms'
		when 'PR'
		  'Proverbs'
		when 'EC'
		  'Ecclesiastes'
		when 'SS'
		  'Song+of+Solomon'
		when 'IS'
		  'Isaiah'
		when 'JE'
		  'Jeremiah'
		when 'LA'
		  'Lamentations'
		when 'EZ'
		  'Ezekiel'
		when 'DA'
		  'Daniel'
		when 'HO'
		  'Hosea'
		when 'JL'
		  'Joel'
		when 'AM'
		  'Amos'
		when 'OB'
		  'Obadiah'
		when 'JH'
		  'Jonah'
		when 'MI'
		  'Micah'
		when 'NA'
		  'Nahum'
		when 'HB'
		  'Habakkuk'
		when 'ZP'
		  'Zephaniah'
		when 'HG'
		  'Haggai'
		when 'ZC'
		  'Zechariah'
		when 'MI'
		  'Malachi'
		when 'MT'
		  'Matthew'
		when 'MK'
		  'Mark'
		when 'LK'
		  'Luke'
		when 'JN'
		  'John'
		when 'AC'
		  'Acts'
		when 'RO'
		  'Romans'
		when '1C'
		  '1Corinthians'
		when '2C'
		  '2Corinthians'
		when 'GA'
		  'Galatians'
		when 'EP'
		  'Ephesians'
		when 'PP'
		  'Philippians'
		when 'CO'
		  'Colossians'
		when '1TH'
		  '1Thessalonians'
		when '2TH'
		  '2Thessalonians'
		when '1T'
		  '1Timothy'
		when '2T'
		  '2Timothy'
		when 'TI'
		  'Titus'
		when 'PM'
		  'Philemon'
		when 'HE'
		  'Hebrews'
		when 'JM'
		  'James'
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
		when 'JU'
		  'Jude'
		when 'RV'
		  'Revelation'
                else
                  book
              end

            verse_ref = "Not found for https://bible-api.com/#{book}+#{chapter}:#{verse}?translation=kjv" 
            bible_verse = HTTParty.get("https://bible-api.com/#{book}+#{chapter}:#{verse}?translation=kjv").body
            bible_verse_data = JSON.parse(bible_verse,{:symbolize_names => true})
            if bible_verse_data[:reference]
              verse_ref = "#{bible_verse_data[:text].strip.gsub(/\s+/, " ")} - #{bible_verse_data[:reference]}"
            end
          end
          return verse_ref
        end

        def get_movie(summary)
          md = /Certi*ficate #(\d{1,})/.match summary
          if !md
            'No certificate # found'
          else
            cert_number = md[1]
            google_search_movie(cert_number) ||
              local_file_search_movie(cert_number) ||
              filmsonsuper8_search_movie(cert_number) ||
              "No movie found for #{cert_number}"
          end
        end

        def local_file_search_movie(cert_number)
          rows = all_movies.select { |r| r["Certificate"] == cert_number}
          return nil if rows.empty?
          result = rows.first
          "#{result['Name']} (#{result['Year']})"
        end

        def filmsonsuper8_search_movie(cert_number)
          html = HTTParty.get("https://www.filmsonsuper8.com/censorship/mpaa-film-numbers-52000.html").body
          document = Nokogiri::HTML.parse(html)
          result = document.xpath("//table/tr[./td[text()='#{cert_number}']]/td").map {|n| n.text}
          return nil if (result.empty? || result[0].empty?)
          "#{result[2]} (#{result[0]})"
        end

        def google_search_movie(cert_number)
          google_string = "https://customsearch.googleapis.com/customsearch/v1?" +
            "c2coff=0&" +
            "cx=#{File.read("#{File.dirname(__FILE__)}/google-search-engine.txt")}&" +
            "exactTerms=certificate%20%23#{cert_number}&" +
            "filter=1&" +
            "lr=lang_en&" +
            "num=1&" +
            "key=#{File.read("#{File.dirname(__FILE__)}/google-search-api-key.txt")}"
          google_result_doc = HTTParty.get(google_string, format: :plain, headers: { 'Accept' => 'application/json' })
          google_result = JSON.parse(google_result_doc, symbolize_names: true)
          return nil if (google_result[:items].nil? || google_result[:items].empty?)
          title = google_result[:items].first[:title]
          md = /(.*) - IMDb/.match title
          return nil unless md
          md[1]
        end

        def generate(entry)
          doc = <<~EOF
          #{entry['title']}
          The latest entry has entered the vault i#{entry['summary'][1..].strip}
          #{get_verse(entry['title'])}
          Related Movie: #{get_movie(entry['summary'])}
          You can support the important work of The Omnibus Project here \
          https://www.patreon.com/omnibusproject/ and find merch at \
          https://www.omnibusproject.com/store
          #{entry['url']}
          EOF
        end

        def all_movies
          doc = File.new File.realdirpath('mpaa-certs.csv',File.dirname(__FILE__))
          return CSV.parse(doc, headers: true)
        end
      end
    end
  end
end
