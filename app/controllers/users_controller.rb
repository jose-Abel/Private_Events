class UsersController < ApplicationController
	before_action :set_user, only: [:show]

	before_action :require_same_user, only: [:show]
	
	def new
		@user = User.new
		if logged_in?
			redirect_to users_path
		end
	end

	def create
		@user = User.new(user_params)
		if @user.save
			session[:user_id] = @user.id
			flash[:notice] = "Welcome #{@user.first_name} to the Private Events app"
			redirect_to users_path
		else
			flash[:alert] = user.errors.full_messages
			redirect_to "new"
		end
	end

	def show
	end

	private

	def set_user
		unless logged_in?
			redirect_to login_path
		else
			@user = User.find(session[:user_id])
		end
	end

	def user_params
		params.require(:user).permit(:first_name, :last_name, :email, :password)
	end

	def require_same_user
    if current_user != @user
      flash[:alert] = "You can only see your own events"
      redirect_to users_path
    end
  end

end
