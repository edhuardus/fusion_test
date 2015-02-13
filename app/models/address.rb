class Address
  include Mongoid::Document
  include Mongoid::Timestamps
  include Geocoder::Model::Mongoid

  # === Fields definitions

  # Address
  field :zip_code,                :type => String
  field :address_state,           :type => String
  field :municipality_name,       :type => String
  field :human_settlement_name,   :type => String
  field :name_road,               :type => String
  field :number_ext,              :type => String
  field :number_int,              :type => String

  field :coordinates,             :type => Array

  geocoded_by :full_address
  #after_validation :geocode
  before_validation :geocode

  # === Relationships definitions
  embedded_in :addresseable

  #validates
  validates_presence_of :zip_code, :address_state, :municipality_name, :human_settlement_name, :name_road, :number_ext

  def self.states_collections
    State.all.collect(&:name)
  end

  def full_address
    "#{name_road} #{number_ext}, #{zip_code}, #{municipality_name}, Mexico"
  end

end