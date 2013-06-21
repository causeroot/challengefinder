class Challenge < ActiveRecord::Base
  attr_accessible :award, :deadline, :description, :image_url, :name, :post_date, :rules, :url, :xpath
  validates :name, :presence => true
  has_many :award
  has_many :deadline
  accepts_nested_attributes_for :award
  accepts_nested_attributes_for :deadline
  
  searchable do
	  text :name, :stored => true
    text :description, :stored => true
  end  
end
