# Reloc

A super simple way to generate easy to read, hard to guess, domain specific unique IDs.

## Installation

Install the gem:

    $ gem install reloc

Then require it

	require 'reloc'

## Usage

Throw Reloc an (auto-incrementing) integer to generate easy to read, hard to guess unique IDs.

	Reloc.generate( 12345 )
	#	=>	"7bmgk"
	Reloc.generate( 12346 )
	#	=>	"2wrdt"

You can ensure your IDs are domain specific

	Reloc.generate( 12345, 'www.somedomain.com' )
	#	=>	"8fgqb"
	Reloc.generate( 12345, 'www.anotherdomain.com' )
	#	=>	"oswn1"

And configure the minimum ID length (default is 5 characters)

	Reloc.config( {:min_chars => 3} )
	Reloc.generate( 12345 )
	#	=>	"8z7"	

Hook it up to [Redis][redis] and you've got your own URL shortener in just a few lines of code

	require 'redis'
	require 'reloc'
	
	redis = Redis.new
	redis.set( "counter", 0 )

	counter = Reloc.generate( redis.incr "counter" )
	#	=> "68hy1"

	redis.set( counter, "http://some-url.com" )
	#	=> OK

	redis.get( "68hy1" )
	#	=> "http://some-url.com"

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

[redis]:http://redis.io/
