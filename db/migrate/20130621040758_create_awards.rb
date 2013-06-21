class CreateAwards < ActiveRecord::Migration
  def change
    create_table :awards do |t|
      t.string :value
      t.text :description

      t.timestamps
    end
  end
end
