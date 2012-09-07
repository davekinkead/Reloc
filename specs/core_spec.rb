require 'minitest/spec'
require 'minitest/autorun'
require 'reloc/core'

describe 'Reloc' do

  describe 'salt' do
    it 'should generate a random order of 0-9 a-z' do
      salt = Reloc.salt
      salt.must_be_kind_of String
      salt.length.must_equal 36
      salt.split( // ).sort.must_equal (('0'..'9').to_a + ('a'..'z').to_a).join.split( // )
    end
  end

  describe 'encode' do

    before do
      Reloc.config( { :min_chars => 5 } )
    end

    it 'should return nil on error' do
      Reloc.generate( 'string' ).must_be_nil
      Reloc.generate( 12.7 ).must_be_nil
    end

    it 'should return alphanum of default length 5 for some int' do
      Reloc.generate( 123456 ).length.must_equal 5
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
    #   which theoretically shouldn't occur as extra digets just
    #   get added when n gets larger
    it 'should pass duplicate test for x million tries' do
      results = []
      10000.times { |n| results << Reloc.generate( n ) }
      results.length.must_equal results.uniq.length
    end
  end

  describe 'config' do
    it 'should set minimum characters to return' do
      env = Reloc.config( { :min_chars => 3 } )
      env[:min_chars].must_equal 3
      Reloc.generate( 27 ).length.must_equal 3
    end
  end
end