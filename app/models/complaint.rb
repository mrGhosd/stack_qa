class Complaint < ActiveRecord::Base
  belongs_to :user
  belongs_to :complaintable, polymorphic: true, touch: true
end