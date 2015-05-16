class Admin::ComplaintsController < AdminController
  def index
    @complaints = Complaint.paginate(page: params[:page] || 1, per_page: 20).order(created_at: :desc)
  end
end