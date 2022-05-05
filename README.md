# Pod::Poster

Monitor a podcast RSS feed and make a post to Facebook when a new podcast episode is released


    $ gem install pod-poster

## Usage
Call `pod-poster` with the `generate` command.
```
$ pod-poster generate
```

That will yield something that looks like this:
```
https://www.omnibusproject.com/460
Episode 460: The Holy Prepuce (Entry 594.JS0503) 
The latest entry has entered the vault in which Apocrypha gospel adventures and medieval miracles are ascribed to the sacred foreskin of Jesus of Nazareth, and Ken disapproves of hand magic in our schools. Certificate #52348.
And Joshua made him sharp knives, and circumcised the children of Israel at the hill of the foreskins. - Joshua 5:3
Related Movie: No movie found for 52348
You can support the important work of The Omnibus Project here https://www.patreon.com/omnibusproject/ and find merch at https://www.omnibusproject.com/store
```
Note that the movie lookup didn't work. You will need to look that up separately. The databases are incomplete.

1. Copy and past that whole thing into a new posting in Facebook.
2. Add the movie info if it couldn't be found.
3. Highlight the last sentence - "You can support..." - and put it in *italics*.
4. Highlight the bible verse and make it a quote.
5. Delete the first line with the link to the episode.
6. Highlight the title line - "Episode 460..." - and select `H2`
7. Delete the previews of the patreon and omnibusproject store links so the link to the episode is the only one left. Do this last or else it can get regenerated when making other edits.
8. Post!

It should look similar to this but the title will be in small caps...

---

### Episode 460: The Holy Prepuce (Entry 594.JS0503)

The latest entry has entered the vault in which Apocrypha gospel adventures and medieval miracles are ascribed to the sacred foreskin of Jesus of Nazareth, and Ken disapproves of hand magic in our schools. Certificate #52348.

> And Joshua made him sharp knives, and circumcised the children of Israel at the hill of the foreskins. - Joshua 5:3

Related Movie: Uncut Gems (2019)

*You can support the important work of The Omnibus Project here https://www.patreon.com/omnibusproject/ and find merch at https://www.omnibusproject.com/store*

**Image and Link Here**

---

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mdeangelo001/pod-poster. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/mdeangelo001/pod-poster/blob/master/CODE_OF_CONDUCT.md).


## Code of Conduct

Everyone interacting in the Pod::Poster project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/mdeangelo001/pod-poster/blob/master/CODE_OF_CONDUCT.md).

## Copyright

Copyright (c) 2022 Mike DeAngelo <revmike@gmail.com>. See [Apache License 2.0](LICENSE.txt) for further details.
