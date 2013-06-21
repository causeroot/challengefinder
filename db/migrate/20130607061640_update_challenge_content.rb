class UpdateChallengeContent < ActiveRecord::Migration
  def up
    add_column :challenges, :title, :string
    add_column :challenges, :tag_line, :string
    add_column :challenges, :summary, :text
    add_column :challenges, :eligibility, :text
    add_column :challenges, :fee, :text
    add_column :challenges, :sponsor, :string
    add_column :challenges, :contact_info, :string
    add_column :challenges, :topic, :string
    add_column :challenges, :structure, :string
    add_column :challenges, :resultant, :string
    add_column :challenges, :xpath_check, :string, :default => nil
    remove_column :challenges, :name
    remove_column :challenges, :description
    remove_column :challenges, :award
    remove_column :challenges, :deadline
    remove_column :challenges, :xpath
  end

  def down
    add_column :challenges, :name, :string
    add_column :challenges, :description, :text
    add_column :challenges, :award, :text
    add_column :challenges, :deadline, :datetime
    add_column :challenges, :xpath, :string, :default => nil
    remove_column :challenges, :title
    remove_column :challenges, :tag_line
    remove_column :challenges, :summary
    remove_column :challenges, :eligibility
    remove_column :challenges, :fee
    remove_column :challenges, :sponsor
    remove_column :challenges, :contact_info
    remove_column :challenges, :topic
    remove_column :challenges, :structure
    remove_column :challenges, :resultant
    remove_column :challenges, :xpath_check
  end
end

*Award Value1*
*Award Description1*
*Deadline Date1*
*Deadline Description1*