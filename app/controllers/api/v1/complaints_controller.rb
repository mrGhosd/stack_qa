class Api::V1::ComplaintsController < Api::ApiController
  before_action :doorkeeper_authorize!, only: :create
  include ComplaintsEntities

  def create
    complaint = entity.complaints.new(complaints_params.merge({user_id: current_resource_owner.id}))
    if complaint.save
      render json: complaint.as_json, status: :ok
    else
      render json: complaint.errors.as_json, status: :unprocessable_entity
    end
  end

  private
  def complaints_params
    params.require(:complaint).permit(:user_id, :complaintable_id, :complaintable_type)
  end
end