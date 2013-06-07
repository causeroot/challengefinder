class UpdateChallengeContent < ActiveRecord::Migration
  def up
    add_column :challenges, :sponsor, :string
    add_column :challenges, :tag_line, :string
    add_column :challenges, :summary, :text
    add_column :challenges, :contact_info, :string
    remove_column :challenges, :xpath
	remove_column :challenges, :rules
  end

  def down
    add_column :challenges, :rules, :text
    add_column :challenges, :xpath, :string, :default => nil
    remove_column :challenges, :sponsor
    remove_column :challenges, :tag_line
    remove_column :challenges, :summary
    remove_column :challenges, :contact_info
  end
end

