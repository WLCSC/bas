class CreateBookables < ActiveRecord::Migration
  def change
    create_table :bookables do |t|
	  t.integer :user_id
      t.timestamps
    end
  end
end
