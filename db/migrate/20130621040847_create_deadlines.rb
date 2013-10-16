class CreateDeadlines < ActiveRecord::Migration
  def change
    create_table :deadlines do |t|
      t.datetime :date
      t.text :description
      t.references :challenge

      t.timestamps
    end
  end
end