class AddSpecialToSlot < ActiveRecord::Migration
  def up
    add_column :slots, :special, :boolean
    Slot.all.each do |s|
	    s.special = false
    end
  end

  def down
	  remove_column :slots, :special
  end
end
