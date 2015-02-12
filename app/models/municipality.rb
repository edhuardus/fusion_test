# encoding: utf-8
class Municipality 
  include Mongoid::Document
  include Mongoid::Timestamps

  attr_accessible :state_id, :code, :name

  ##
  # attributes
  field :code,            :type => String
  field :name,            :type => String

  ## 
  #Relation
  belongs_to :state

  has_many :cities, :dependent => :destroy
  has_many :zip_codes, :dependent => :destroy
  has_many :districts

end