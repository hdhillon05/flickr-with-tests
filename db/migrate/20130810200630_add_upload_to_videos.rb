class AddUploadToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :upload, :string
  end
end
