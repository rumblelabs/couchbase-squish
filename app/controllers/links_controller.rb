class LinksController < ApplicationController
  def create
    @link = Link.new(params[:link])
    @link.session_id = session[:session_id]
    if @link.save
      respond_to do |format|
        format.html { redirect_to @link }
        format.js
      end
    else
      respond_to do |format|
        format.html { render :new }
        format.js   { head :status => 500 }
      end
    end
  end

  def short
    @link = Link.find(params[:id])
    redirect_to root_path unless @link
    @link.views += 1
    @link.save
    redirect_to @link.url
  end

  def show
    @link = Link.find(params[:id])
  end
  
  def my
    @filter = "my_links"
    @filtered_links = Link.by_session_id(session[:session_id])
    @link = Link.new
  end
  
  def recent
    @filter = "recent"
    @filtered_links = Link.recent
    @link = Link.new
  end
  
  def popular
    @filter = "popular"
    @filtered_links = Link.popular
    @link = Link.new
  end
  
end