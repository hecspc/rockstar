require File.dirname(__FILE__) + '/../test_helper.rb'

class TestTrack < Test::Unit::TestCase

  def setup
    @track = Scrobbler::Track.new('Carrie Underwood', 'Before He Cheats')
  end
  
  test 'should require the artist name' do
    assert_raises(ArgumentError) { Scrobbler::Track.new('', 'Before He Cheats') }
  end
  
  test 'should require the track name' do
    assert_raises(ArgumentError) { Scrobbler::Track.new('Carrie Underwood', '') }
  end
  
  test "should know the artist" do
    assert_equal('Carrie Underwood', @track.artist)
  end
  
  test 'should know the name' do
    assert_equal('Before He Cheats', @track.name)
  end
  
  test 'should have fans' do
    assert_equal(50, @track.fans.size)
    assert_equal('chelseaf89', @track.fans.first.username)
    assert_equal('http://www.last.fm/user/chelseaf89', @track.fans.first.url)
    assert_equal('http://userserve-ak.last.fm/serve/34/41303325.jpg', @track.fans.first.avatar)
    assert_equal('5000000', @track.fans.first.weight)
  end
  
  test 'should have top tags' do
    assert_equal(100, @track.tags.size)
    assert_equal('country', @track.tags.first.name)
    assert_equal('100', @track.tags.first.count)
    assert_equal('http://www.last.fm/tag/country', @track.tags.first.url)
  end
  
  test 'can love tracks' do
    assert_equal('ok', @track.love("tag"))  
  end

end