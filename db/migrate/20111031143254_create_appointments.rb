class CreateAppointments < ActiveRecord::Migration
  def change
    create_table :appointments do |t|
      t.integer :user_id
      t.integer :slot_id
      t.integer :kind_id
      t.datetime :start
	  t.datetime :end

      t.timestamps
    end
  end
end
