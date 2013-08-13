class Photo < ActiveRecord::Base
  PRICE = 1000 #call this anywhere using: Photo::PRICE
  belongs_to :user
  has_many :comments, as: :commentable
  mount_uploader :upload, UploadUploader
  scoped_search on: [:title, :description] #scope search gem installed already -- this will allow us to search in the photos model


  #CREATE A CONSTANT FOR PRICE OF BUYING PHOTO


end
