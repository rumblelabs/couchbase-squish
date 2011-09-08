class LinksController < ApplicationController

  def index
    @links = Link.most_viewed
    @link = Link.new
  end

end