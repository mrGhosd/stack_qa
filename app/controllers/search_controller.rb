class SearchController < ApplicationController
  skip_authorize_resource

  def index
    @result = if params[:filter].blank?
       ThinkingSphinx.search params[:query]
    else
      params[:filter].constantize.search params[:query] if /Question|Answer|Comment|User/ =~ params[:filter]
    end
    render template: "search/index", layout: false
  end

end