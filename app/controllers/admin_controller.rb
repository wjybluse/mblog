class AdminController < ApplicationController
  def index
  	if signed_in?
		  @micropost = current_user.microposts.build
		  @feed_items=current_user.feed
	 end
  end

  def about
  end

  def contact
  end
end
