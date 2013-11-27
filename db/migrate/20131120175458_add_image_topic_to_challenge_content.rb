class AddImageTopicToChallengeContent < ActiveRecord::Migration
  def up
    add_column :challenges, :image_topic, :text
  end

  def down
    remove_column :challenges, :image_topic
  end
end

