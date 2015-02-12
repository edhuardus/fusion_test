class Address
  include Mongoid::Document
  include Mongoid::Timestamps

  # === Fields definitions

  # Address
  field :zip_code,                :type => String
  field :address_state,           :type => String
  field :municipality_name,       :type => String
  field :name_locality,           :type => String
  field :human_settlement_name,   :type => String
  field :type_of_road,            :type => String
  field :name_road,               :type => String
  field :number_ext,              :type => String
  field :number_int,              :type => String

  # === Relationships definitions
  embedded_in :addresseable

end