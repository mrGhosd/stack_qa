class Question < ActiveRecord::Base
  validates_presence_of :title, :text
  validates_uniqueness_of :title
end