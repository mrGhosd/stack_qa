class ComplaintsController < ApplicationController
  include ComplaintsEntities

  def create
    complaint = entity.complaints.new(complaints_params.merge({user_id: current_user.id}))
    if complaint.save
      render json: {success: true}, status: :ok
    else
      render json: {success: false}, status: :unprocessable_entity
    end
  end

  private
  def complaints_params
    params.require(:complaint).permit(:user_id, :complaintable_id, :complaintable_type)
  end
end