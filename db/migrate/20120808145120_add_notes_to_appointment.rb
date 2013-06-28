class AddNotesToAppointment < ActiveRecord::Migration
  def change
    add_column :appointments, :notes, :text
  end
end
