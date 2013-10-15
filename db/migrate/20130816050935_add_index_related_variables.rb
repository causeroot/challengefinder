class AddIndexRelatedVariables < ActiveRecord::Migration
  # For now make the default assumption that all awards will be integers and denominated in USD.
  def up
    add_column :challenges, :numeric_value, :integer
    add_column :challenges, :index_deadline, :text
  end

  def down
    remove_column :challenges, :numeric_value
    remove_column :challenges, :index_deadline
  end
end
