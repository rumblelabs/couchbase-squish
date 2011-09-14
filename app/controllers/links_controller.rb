class LinksController < ApplicationController

  def index
    @popular = Link.popular
    @recent = Link.recent
    @my_links = Link.by_session_id(session[:session_id])
    @link = Link.new
  end

  def create
    @link = Link.new(params[:link])
    @link.session_id = session[:session_id]
    if @link.save
      redirect_to @link
    else
      render :new
    end
  end

  def view
    @link = Link.find(params[:id])
    redirect_to root_path unless @link
    @link.views += 1
    @link.save
    redirect_to @link.url
  end

  def show
    @link = Link.find(params[:id])
  end
  
end