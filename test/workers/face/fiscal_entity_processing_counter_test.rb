require 'test_helper'
require "vcr"

class Face::FiscalEntityWorkerTest < Minitest::Test
  def test_fiscal_entity_processing_counter
    counter = Face::FiscalEntityProcessingCounter.new
    counter.increment_processed
    counter.increment_imported
    counter.increment_ignored

    processed, imported, ignored = counter.status

    assert_equal 1, processed
    assert_equal 1, imported
    assert_equal 1, ignored
  end
end
