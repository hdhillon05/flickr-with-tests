class AddUploadToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :upload, :string
  end
end
