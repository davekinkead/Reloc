module Reloc

  @@env = {
    :min_chars => 5,
    :domain => nil,
  }
  @@salts = { nil => 'mq6w2ueiayxgj7th4380r15zcdbkvlspo9fn'.split( // )  }  #   Generate a new code with (('0'..'9').to_a + ('a'..'z').to_a).shuffle.join
  ALPH = (('0'..'9').to_a + ('a'..'z').to_a).join.split( // )

  # Public: Generate a random ordering of an alphanumeric-bet
  #
  # Example
  #
  #   Reloc.salt
  #   # =>  'z2y54c8pnwrl63o17hxmbtauqegd0vfi9ksj'
  #
  # Returns a random ordering of an alphanumeric-bet
  def self.salt
    ( ('0'..'9').to_a + ('a'..'z').to_a ).shuffle.join
  end

  # Public: Sets configuration variables
  #
  # min_chars - The minimum characters to generate in a reloc
  #
  # Example
  #
  # Returns the current config variables
  def self.config( env={} )
    env.each { |k,v| @@env[k] = v }
    @@env
  end

  # Public: Generate a unique reloc for some integer + domain pair
  #
  # num       - The integer to be encoded
  # domain    - The domain constraint on uniqueness
  #
  # Example
  #
  #   Reloc.generate( 123456, 'some domain' )
  #   # =>  ''
  #
  #  Returns the encoded integer or nil on error
  def self.generate( num, domain=nil )
    return nil unless num.instance_of? Fixnum
    incr = num % 36
    num += ( 36**(@@env[:min_chars] - 1) )
    b36 = num.to_s(36).split(//)
    res = []
    b36.each do |s|
      res << @@salts[domain][( ALPH.index( s ) + incr * 2 ) % 36]
      incr += 1
    end
    res.join
  end
end
