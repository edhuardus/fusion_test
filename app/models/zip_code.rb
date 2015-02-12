# encoding: utf-8
class ZipCode
  include Mongoid::Document
  include Mongoid::Timestamps

  attr_accessible :municipality_id, :city_id, :code

  ##
  # attributes
  field :code,            :type => String

  ## 
  #Relation
  belongs_to :municipality
  belongs_to :city

  has_many :districts, :dependent => :destroy


end