class UpdateChallengeContentWithStatus < ActiveRecord::Migration
  def up
    add_column :challenges, :status, :string
  end
end
