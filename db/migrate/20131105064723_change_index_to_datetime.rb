class ChangeIndexToDatetime < ActiveRecord::Migration
  def up
    remove_column :challenges, :index_deadline
    add_column :challenges, :index_deadline, :datetime
    add_index :challenges, :index_deadline 
  end

  def down
    remove_column :challenges, :index_deadline
    add_column :challenges, :index_deadline, :text
  end
end
