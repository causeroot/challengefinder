class Challenge < ActiveRecord::Base
  attr_accessible :url, :title, :tag_line, :summary, :rules, :eligibility, :fee, :award, :deadline, :post_date, :image_url, :sponsor, :contact_info, :topic, :structure, :resultant, :xpath_check
  validates :title, :presence => true
  has_many :award
  has_many :deadline
  accepts_nested_attributes_for :award
  accepts_nested_attributes_for :deadline
  
  searchable do
	  string :title, :stored => true
    string :tag_line, :stored => true
    text :summary, :stored => true
    text :rules, :stored => true
    text :eligibility, :stored => true
    text :fee, :stored => true
    string :sponsor, :stored => true
    text :contact_info, :stored => true
  end  
end