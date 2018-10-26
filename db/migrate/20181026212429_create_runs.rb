class CreateRuns < ActiveRecord::Migration[5.2]
  def change
    create_table :runs do |t|
      t.string :date
      t.string :name
      t.float :distance
      t.string :duration
      t.string :pace_per_mile
      t.text :notes
      t.integer :number_intervals
      t.string :interval_length
      t.string :rest_between_interval
      t.integer :month_id
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
