
class Face::FiscalEntityProcessingCounter

  def initialize
    @processed = 0
    @imported = 0
    @ignored = 0
  end

  def increment_processed
    @processed += 1
  end

  def increment_imported
    @imported += 1
  end

  def increment_ignored
    @ignored += 1
  end

  def status
    return @processed, @imported, @ignored
  end
end