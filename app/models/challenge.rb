class Challenge < ActiveRecord::Base
  has_many :awards
  has_many :deadlines
  accepts_nested_attributes_for :awards, :reject_if => proc { |a| a['value'].blank? and a['description'].blank? }
  accepts_nested_attributes_for :deadlines, :reject_if => proc { |a| a['date'].blank? and a['descrioption'].blank? }
  
  attr_accessible :url, :title, :tag_line, :summary, :rules, :eligibility, :fee, :awards_attributes, :deadlines_attributes, :post_date, :image_url, :sponsor, :contact_info, :topic, :structure, :resultant, :xpath_check
  validates :title, :presence => true
  
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
