class UpdateChallengeContentWithStatus < ActiveRecord::Migration
  def up
    add_column :challenges, :status, :string
  end

  def down
    remove_column :challenges, :title, :string
  end
end
