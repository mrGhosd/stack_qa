class SearchController < ApplicationController
  skip_authorize_resource

  def index
    @collection = ThinkingSphinx.search "#{params[:query]}*", star: true
    if params[:full_list].present?
      render template: "search/index"
    else
      render json: @collection.as_json(except: :tags)
    end

  end
end
