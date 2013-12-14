class UsersController < ApplicationController
  before_action :set_user, only: [:update,:edit,:show,:correct_user]
  before_action :signed_in_user ,only: [:index, :update,:edit]
  before_action :correct_user ,only: [:update,:edit]
  before_action :admin_user,only: :destroy
  def new
  	@user=User.new
  end

  def index
  	@users=User.all
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success]="Profiles Update Success!"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def show 
    @microposts=@user.microposts
  end

  def create
  	@user=User.new(user_params)
  	if @user.save
        sign_in @user
  			flash.now[:success]="Welcome to Mirco Blog #{@user.name}"
        redirect_to @user 
  	else
  			render 'new'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    if !current_user.admin?
      current_user=nil
    end
    redirect_to users_url
  end

  private
    def set_user
      @user = User.find(params[:id])
    end
  	def user_params
  		params.require(:user).permit(:name, :email, :password, :password_confirmation)
  	end

    def correct_user
      redirect_to root_path unless correct_user?(@user)
    end

    def admin_user
      redirect_to root_path unless current_user.admin?
    end
end
