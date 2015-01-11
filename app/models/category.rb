class Category < ActiveRecord::Base
  has_many :questions

  mount_uploader :image, CategoryUploader
end