# encoding: utf-8
class District 
  include Mongoid::Document
  include Mongoid::Timestamps

  attr_accessible :zip_code_id, :municipality_id, :district_type_id, :name

  ##
  # attributes
  field :name,            :type => String

  ## 
  #Relation
  belongs_to :zip_code
  belongs_to :municipality
  belongs_to :district_type

  has_and_belongs_to_many :municipalities

end