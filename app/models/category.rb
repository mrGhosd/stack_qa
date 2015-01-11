class Category < ActiveRecord::Base
  has_many :questions

  mount_uploader :image, CategoryUploader

  validates :title, :description, presence: true
  validates :title, uniqueness: true
end