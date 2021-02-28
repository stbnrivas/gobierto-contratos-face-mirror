require "test_helper"
require "vcr"
#require "webmock/minitest"

class Face::OrganismTest < ActiveSupport::TestCase
  test "default pagination size is 25" do
    assert_equal 25.0, Face::Organism::PAGINATION_SIZE # 25 is the default pagination for angular app to be unseen
  end

  test "organism level 1 has 44 items" do
    VCR.use_cassette("organism_level1_has_44_elements") do
      assert_equal 44, Face::Organism.count(1)
    end
  end

  test "organism level 1 has 2 pages" do
    VCR.use_cassette("organism_level1_has_2_pages") do
      assert_equal 2, Face::Organism.last_page(1)
    end
  end

  test "organism level 1 page 1 has 25 elements" do
    VCR.use_cassette("organism_level1_page_1") do
      expected = ["E04585801", "E05024101", "E04921401", "E00003601", "E04921301", "E04921601", "E05024401", "E05024901", "E04921501", "E00004101", "E04990301", "E00003801", "E04990401", "E04921701", "E00003901", "E04921901", "E04990101", "EA0008567", "E04990501", "E04990201", "E00003301", "E04921801", "E05023901", "E05025101", "E05024801"]
      assert_equal expected, Face::Organism.directory_organism_for(1,1)
    end
  end

  test "organism level 1 page 2 has 19 elements" do
    VCR.use_cassette("organism_level1_page_2") do
      expected = ["E05024201", "E05024701", "E05065601", "E05071301", "E05071601", "E05068001", "E05024301", "E05068901", "E05072201", "E05072501", "E05067101", "E05024501", "E05024601", "E05070101", "E05066501", "E05024001", "E05025001", "E05070401", "E05073401"]
      assert_equal expected, Face::Organism.directory_organism_for(1,2)
    end
  end

  test "organism level 1 full has x elements" do
    VCR.use_cassette("organism_level1_full") do
      expected = ["E04585801", "E05024101", "E04921401", "E00003601", "E04921301", "E04921601", "E05024401", "E05024901", "E04921501", "E00004101", "E04990301", "E00003801", "E04990401", "E04921701", "E00003901", "E04921901", "E04990101", "EA0008567", "E04990501", "E04990201", "E00003301", "E04921801", "E05023901", "E05025101", "E05024801", "E05024201", "E05024701", "E05065601", "E05071301", "E05071601", "E05068001", "E05024301", "E05068901", "E05072201", "E05072501", "E05067101", "E05024501", "E05024601", "E05070101", "E05066501", "E05024001", "E05025001", "E05070401", "E05073401"]
      assert_equal expected, Face::Organism.directory_organism(1)
    end
  end
end



