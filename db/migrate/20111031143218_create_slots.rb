class CreateSlots < ActiveRecord::Migration
  def change
    create_table :slots do |t|
      t.string :name
      t.integer :bookable_id
	  t.integer :start_time
	  t.integer :end_time

      t.timestamps
    end
  end
end
