class SearchController < ApplicationController
  skip_authorize_resource

  def index
    @result = ThinkingSphinx.search params[:query]
    render template: "search/index", layout: false
  end

end