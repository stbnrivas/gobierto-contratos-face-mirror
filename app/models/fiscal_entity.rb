# frozen_string_literal: true

class FiscalEntity < ApplicationRecord
  CIF_LETTERS = %w(A B C D E F G H J N P Q R S U V W).freeze
  CIF_FORMAT = /\A(#{CIF_LETTERS.join("|")})\d{8}\z/.freeze
  NIF_FORMAT = /\A\d{8}[A-Z]\z/.freeze
  NIE_FORMAT = /\A[A-Z]\d{7}[A-Z]\z/.freeze
  LOCAL_ENTITY_CIF_FORMAT = /\AP\d{7}[A-Z]\z/.freeze

  DIR3_FORMATS = [
    /\ALA\d{7}\z/, # LA1234567
    # Also same places have removed the leading zeroes, i.e: L01442656 => L1442656
    /\ALO\d{7}\z/, # LO1234567 - 19 city councils have confused 0 with O. TODO: replace all with 0's and merge results
    /\AL\d{7}[A-Z]\z/, # LO1234567X
    /\AS\d{7}[A-Z]\z/, # S1234567A
    /\AQ\d{7}[A-Z]\z/, # Q1234567D
    /\A(EA|GE)\d{7}\z/, # EA1234567 / GE0005974
    /\A(E|A|U|I|L)\d{8}\z/ # L12345678 / E12345678 / A12345678 / U02900001 / I00000021
  ].freeze

  include JsonPrint

  # source: https://contrataciondelestado.es/codice/cl/1.04/ContractingAuthorityCode-1.04.gc
  enum entity_type: {
    company: 0, # Empresas privadas
    government_administration: 1, # Administración General del Estado (ministerios)
    autonomous_region_council: 2, # Comunidad Autónoma
    province_council: 3, # Diputación provincial
    city_council: 4, # Ayuntamientos
    public_organization: 5, # Entidad de Derecho Público / Otras Entidades del Sector Público
    ute: 6
  }

  enum external_id_type: {
    CIF: 0,
    NIF: 1,
    DIR3: 2,
    UTE: 3,
    OTROS: 4,
    ID_UTE_TEMP_PLATAFORMA: 5
  }

  scope :unclassified, lambda {
    where(entity_type: nil).or(
      autonomous_region_council.where(autonomous_region_id: nil)
    ).or(
      province_council.where(province_id: nil)
    ).or(
      city_council.where(place_id: nil)
    )
  }

  scope :is_contractor, -> { where(is_contractor: true) }
  scope :is_assignee, -> { where(is_assignee: true) }
  scope :import_pending, -> { where(import_pending: true) }

  before_validation :set_slug

  validates :name, presence: true
  validate :validate_dir3_format
  validate :validate_nifs_format

  def self.find_by_identifiers(identifier_attributes)
    return nil if identifier_attributes.blank?

    identifier_attributes = identifier_attributes.symbolize_keys

    conditions = []
    conditions_attributes = []
    if identifier_attributes[:nifs].present?
      conditions.push("nifs @> ARRAY[?]::varchar[]")
      conditions_attributes.push(identifier_attributes[:nifs])
    end
    if identifier_attributes[:dir3].present?
      conditions.push("dir3 = ?")
      conditions_attributes.push(identifier_attributes[:dir3])
    end
    if identifier_attributes[:ute_id].present?
      conditions.push("ute_id = ?")
      conditions_attributes.push(identifier_attributes[:ute_id])
    end
    if identifier_attributes[:name].present?
      conditions.push("slug = ?")
      conditions_attributes.push(calculate_slug(identifier_attributes[:name]))
    end

    return nil if conditions.empty?

    FiscalEntity.where(conditions.join(" OR "), *conditions_attributes).first
  end

  def self.calculate_slug(name)
    name.gsub(/[^\w\d]*/,'').parameterize if name.present?
  end

  private

  def validate_nifs_format
    if !nifs.blank? && !(nifs.all? { |nif| nif.match?(NIF_FORMAT) || nif.match?(CIF_FORMAT) || nif.match?(NIE_FORMAT) })
      errors.add(:nifs, "has an invalid format: #{nifs}")
    end
  end

  def validate_dir3_format
    if !dir3.blank? && !(DIR3_FORMATS.any? { |regexp| dir3.match?(regexp) })
      errors.add(:dir3, "has an invalid format: #{dir3}")
    end
  end

  def set_slug
    self.slug = self.class.calculate_slug(self.name)
  end

end
