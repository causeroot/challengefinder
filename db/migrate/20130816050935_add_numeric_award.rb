class AddNumericAward < ActiveRecord::Migration
  # For now make the default assumption that all awards will be integers and denominated in USD.
  def up
    add_column :awards, :numeric_value, :integer
  end

  def down
    remove_column :awards, :numeric_value, :integer
  end
end
