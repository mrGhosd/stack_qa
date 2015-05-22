class SearchController < ApplicationController
  skip_authorize_resource

  def index
    collection = ThinkingSphinx.search "#{params[:query]}*", star: true
    render json: collection.as_json(except: :tags)
  end
end
