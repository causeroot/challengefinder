class Challenge < ActiveRecord::Base
  has_many :awards
  has_many :deadlines
  accepts_nested_attributes_for :awards, :reject_if => proc { |a| a['value'].blank? and a['description'].blank? }
  accepts_nested_attributes_for :deadlines, :reject_if => proc { |a| a['date'].blank? and a['description'].blank? }
  
  attr_accessible :url, :title, :status, :tag_line, :summary, :rules, :eligibility, :fee, :numeric_value, :index_deadline, :index_deadline_str, :awards_attributes, :deadlines_attributes, :post_date, :image_url, :sponsor, :contact_info, :topic, :structure, :resultant, :xpath_check, :index_deadline_str
  validates :title, :presence => true

  searchable do
	  string :title, :stored => true
    string :tag_line, :stored => true
    time :index_deadline
    time :post_date
    integer :numeric_value
    text :summary, :stored => true
    text :rules, :stored => true
    text :eligibility, :stored => true
    text :fee, :stored => true
    string :sponsor, :stored => true
    text :contact_info, :stored => true
  end

  def due_at_string
    due_at.to_s(:db)
  end

  def due_at_string=(due_at_str)
    self.due_at = Time.parse(due_at_str)
  end
  
  def index_deadline_str=(i)
    self.index_deadline = Chronic.parse(i)
  end

  def index_deadline_str
    if index_deadline.nil?
      return 'No Deadline'
    else
      index_deadline.to_date.to_formatted_s(:long)
    end
  end
end
