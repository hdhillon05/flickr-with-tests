class Photo < ActiveRecord::Base
  
  before_save :set_price_in_cents
  
  belongs_to :user
  has_many :comments, as: :commentable
  mount_uploader :upload, UploadUploader
  scoped_search on: [:title, :description] #scope search gem installed already -- this will allow us to search in the photos model



  def set_price_in_cents
    self.price = convert_price_to_cents(self.price)
  end

  private

  def convert_price_to_cents(price_in_dollars)
    ((price_in_dollars.to_f)*100).round
  end

end
