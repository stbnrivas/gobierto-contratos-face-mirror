# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.human_enum_name(enum_name, enum_value)
    return nil if enum_value.blank?

    I18n.t("activerecord.attribute_enums.#{model_name.i18n_key}.#{enum_name.to_s.pluralize}.#{enum_value}", default: '')
  end

  def self.human_date_name field, value
    return value.to_s.to_i if value.to_s.to_i != 0

    I18n.t("activerecord.attribute_enums.#{model_name.i18n_key}.#{field}.#{value}", default: '')
  end
end
