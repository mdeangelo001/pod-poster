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
		when 'GN'
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
		  '1 Samuel'
		when '2S'
		  '2 Samuel'
		when '1K'
		  '1 Kings'
		when '2K'
		  '2 Kings'
		when '1CH'
		  '1 Chronicles'
		when '2CH-'
		  '2 Chronicles'
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
		  'Song of Solomon'
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
		  '1 Corinthians'
		when '2C'
		  '2 Corinthians'
		when 'GA'
		  'Galatians'
		when 'EP'
		  'Ephesians'
		when 'PP'
		  'Philippians'
		when 'CO'
		  'Colossians'
		when '1TH'
		  '1 Thessalonians'
		when '2TH'
		  '2 Thessalonians'
		when '1T'
		  '1 Timothy'
		when '2T'
		  '2 Timothy'
		when 'TI'
		  'Titus'
		when 'PM'
		  'Philemon'
		when 'HE'
		  'Hebrews'
		when 'JM'
		  'James'
		when '1P'
		  '1 Peter'
		when '2P'
		  '2 Peter'
		when '1J'
		  '1 John'
		when '2J'
		  '2 John'
		when '3J'
		  '3 John'
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
          movie_ref = 'No match found'
          if md
            movie_ref = "No movie found for #{md[1]}"
            rows = all_movies.select { |r| r["Certificate"] == md[1] }
            if rows.length > 0
              result = rows.first
              movie_ref = "#{result['Name']} (#{result['Year']})"
            else
              html = HTTParty.get("https://www.filmsonsuper8.com/censorship/mpaa-film-numbers-52000.html").body
              document = Nokogiri::HTML.parse(html)
              result = document.xpath("//table/tr[./td[text()='#{md[1]}']]/td").map {|n| n.text}
              movie_ref = "#{result[2]} (#{result[0]})" unless result.empty? || result[0].empty?
            end
          end
          return movie_ref
        end

        def generate(entry)
          doc = <<~EOF
          #{entry['url']}
          #{entry['title']}
          The latest entry has entered the vault i#{entry['summary'][1..].strip}
          #{get_verse(entry['title'])}
          Related Movie: #{get_movie(entry['summary'])}
          You can support the important work of The Omnibus Project here \
          https://www.patreon.com/omnibusproject/ and find merch at \
          https://www.omnibusproject.com/store
          EOF
        end

        def all_movies
          doc = File.realdirpath('mpaa-certs.csv',File.dirname(__FILE__))
          return CSV.parse(doc, headers: true)
        end
      end
    end
  end
end
