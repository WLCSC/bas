class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
	  t.string :name
      t.boolean :administrator

      t.timestamps
    end
  end
end
