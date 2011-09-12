class LinksController < ApplicationController

  def index
    @links = Link.popular
    #@mine = Link.by_session(session[:session_id])
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

  def show
    @link = Link.find(params[:id])
    redirect_to root_path unless @link
    @link.views += 1
    @link.save
    redirect_to @link.url
  end

end