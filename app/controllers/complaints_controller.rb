class ComplaintsController < ApplicationController
  include ComplaintsEntities

  def create
    complaint = entity.complaints.cre
  end

  private
  def complaints_params
    params.require(:complaint).permit(:user_id, :complaintable_id, :complaintable_type)
  end
end