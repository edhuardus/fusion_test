# encoding: utf-8
class Country
  include Mongoid::Document
  include Mongoid::Timestamps

  attr_accessible :iso, :name
  
  ##
  # attributes
  field :iso,              :type => String
  field :name,             :type => String

  ## 
  #Relation
  has_many :states, :dependent => :destroy
 
end

