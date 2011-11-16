class AddAvatarToBookable < ActiveRecord::Migration
  def change
    add_column :bookables, :avatar_file_name, :string
    add_column :bookables, :avatar_content_type, :string
    add_column :bookables, :avatar_file_size, :integer
    add_column :bookables, :avatar_updated_at, :datetime
  end
end
