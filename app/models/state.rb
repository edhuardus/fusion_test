# encoding: utf-8
class State 
  include Mongoid::Document
  include Mongoid::Timestamps

  attr_accessible :country_id, :code, :name
  
  ##
  # attributes
  field :code,            :type => String
  field :name,            :type => String

  ## 
  #Relation
  belongs_to :country

  has_many :municipalities, :dependent => :destroy
 

end