class MicropostsController < ApplicationController
  before_action :signed_in_user, only: [:create, :destroy]
  def index
  	#@microposts=current_user.microposts
  end

  def create
  	blog=current_user.microposts.build(micropost_params)
  	if blog.save
  		redirect_to root_path
  	else
  		render root_path
  	end
  end

  def destroy
    Micropost.find(params[:id]).destroy
    redirect_to root_path
  end

  private 
  def micropost_params
  	 params.require(:micropost).permit(:content)
  end
end
