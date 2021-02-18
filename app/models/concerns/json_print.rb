# frozen_string_literal: true

module JsonPrint

  extend ActiveSupport::Concern

  def print
    puts JSON.pretty_generate(attributes)
  end

end
