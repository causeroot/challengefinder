class AddNumericAward < ActiveRecord::Migration
  def up
    add_column :awards, :numeric_value, :integer
  end

  def down
    remove_column :awards, :numeric_value, :integer
  end
end
