# frozen_string_literal: true

class FiscalEntityFactory

  def self.create!(custom_attributes = {})
    attrs = default_attributes
    attrs.merge!(custom_attributes)
    FiscalEntity.create!(attrs)
  end

  def self.default_attributes
    {
      name: "Nombre #{SecureRandom.hex}",
      external_id: nil,
      external_id_type: nil,
      entity_type: 0, # private company
      place_id: nil,
      province_id: nil,
      autonomous_region_id: nil,
      custom_place_id: nil,
      is_contractor: false,
      is_assignee: false,
      dir3: "U00004051",
      administration_level: nil,
      parent_id: nil,
      nifs: %w(B87344099)
    }
  end

end
