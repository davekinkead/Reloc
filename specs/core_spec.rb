require 'minitest/spec'
require 'minitest/autorun'
require 'reloc/core'

describe 'Reloc' do

  describe 'salt' do
    it 'should generate a random order of 0-9a-z from no arg' do
      salt = Reloc.salt
      salt.must_be_kind_of String
      salt.length.must_equal 36
      salt.split( // ).sort.must_equal (('0'..'9').to_a + ('a'..'z').to_a).join.split( // )
    end

    it 'should generate a domain salt if a domain is provided' do
      salt = Reloc.salt( "I don't always salt my hashes...but when I do" )
      salt.length.must_equal 36
      salt[/[a-z0-9]{36}/].must_equal salt
    end

    it 'should generate a different salt for a different domain' do
      results = []
      100.times do |n|
        results.push( Reloc.salt( "Mumbo number #{n}") )
      end
      results.length.must_equal results.uniq.length
    end
  end

  describe 'config' do
    it 'should return a hash' do
      Reloc.config.must_be_kind_of Hash
    end

    it 'should set minimum characters to return' do
      env = Reloc.config( { :min_chars => 3 } )
      env[:min_chars].must_equal 3
    end

    it 'should set the default domain' do
      domain = 'wiggle**5, yeah you know it!'
      env = Reloc.config( { :domain => domain } )
      env[:domain].must_equal domain
    end
  end

  describe 'encode' do
    before :each do
      Reloc.config( { :min_chars => 5, :domain => nil } )
    end

    it 'should return nil on error' do
      Reloc.generate( 'string' ).must_be_nil
      Reloc.generate( 12.7 ).must_be_nil
    end

    it 'should return alphanum of default length 5 for some int' do
      Reloc.generate( 123456 ).length.must_equal 5
    end

    it 'should return the same ID for the same num+domain pair' do
      Reloc.generate( 123 ).must_equal Reloc.generate( 123 )
    end

    it 'should fail duplicate test check when duplicate is added' do
      results = []
      100.times { |n| results << Reloc.generate( n ) }
      results.length.must_equal results.uniq.length
      # now generate a duplicate
      results << Reloc.generate( 1 )
      results.length.must_equal ( results.uniq.length + 1 )
    end

    # I've tested this to 10 Million times with no collision
    #   which theoretically shouldn't occur as extra digits just
    #   get added when num gets larger
    it 'should pass duplicate test for x million tries' do
      results = []
      100.times { |n| results << Reloc.generate( n ) }
      results.length.must_equal results.uniq.length
    end

    it 'should return the correct number of characters' do
      Reloc.config( { :min_chars => 3 } )
      Reloc.generate( 27 ).length.must_equal 3
    end

    it 'should automatically create a domain specific salt if a domain is provided' do
      config = Reloc.config
      one = Reloc.generate( 12345 )
      config[:salts].has_key?( 'some-domain' ).must_equal false
      two = Reloc.generate( 12345, 'some-domain' )
      config[:salts].has_key?( 'some-domain' ).must_equal true
      one.wont_equal two
      puts Reloc.generate( 1 )

    end
  end
end