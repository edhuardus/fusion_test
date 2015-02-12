# encoding: utf-8
class City 
  #
  include Mongoid::Document
  include Mongoid::Timestamps

  attr_accessible :municipality_id, :code, :name

  ##
  # attributes
  field :code,            :type => String
  field :name,            :type => String

  ## 
  #Relation
  belongs_to :municipality

  has_many :zip_codes, :dependent => :destroy
  has_many :districts, :dependent => :destroy

end