class LinksController < ApplicationController

  def index
    @links = Link.popular
    @link = Link.new
  end

  def create
    @link = Link.new(params[:link])
    if @link.save
      redirect_to @link
    else
      render :new
    end
  end

end