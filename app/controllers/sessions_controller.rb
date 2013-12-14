class SessionsController < ApplicationController
  def new
  end

  def creat
  	user=User.find(params[:session][:email])
  	if user&& user.authenticate(params[:session][:password])
  		sign_in user
  		redirect_back_to user
  	else
  		fash.now[:error]="Invalide user name or password!"
  		render 'new'
  	end
  end

  def destroy
  	signed_out
  	redirect_to root_path
  end
end
