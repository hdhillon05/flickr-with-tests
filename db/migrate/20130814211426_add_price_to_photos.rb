class AddPriceToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :price, :decimal
  end
end
