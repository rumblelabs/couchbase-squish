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
      respond_to do |format|
        format.html { redirect_to @link }
        format.js   { head :status => :success }
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
  
end