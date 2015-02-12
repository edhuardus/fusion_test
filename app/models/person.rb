class Person
  # === Requirements definitions
  include Mongoid::Document
  include Mongoid::Timestamps

  # === Fields definitions

  field :name,                         type: String #nombres
  field :paternal_surname,             type: String #apellido1
  field :maternal_surname,             type: String #apellido2
  field :sex,                          type: String #sexo
  field :birth_date,                   type: Date   #fecha de cumple

  # === Relationships definitions
  embeds_one  :address,                as: :addresseable

  # === Accepts nested definitions
  accepts_nested_attributes_for :address

  #validates
  validates_presence_of :name, :paternal_surname, :maternal_surname, :sex, :birth_date
end