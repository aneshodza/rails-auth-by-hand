class UserController < ApplicationController
  def show
    return unless helpers.logged?

    @user = User.find(helpers.parse_session_token[:id])
  end

  def new
    @user = User.new
  end

  def create
    return if password_not_matches?
    return if invalid_length?
    return if non_unique_username?

    @user = User.new(user_params)
    if @user.save
      redirect_to root_path
    else
      flash[:error] = 'There was an unexpected error :/'
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :password,
                                 :confirmation)
  end

  def invalid_length?
    return false if user_params[:password].length >= 6

    flash[:error] = 'Password must be at least 6 characters'
    redirect_to '/register'
  end

  def password_not_matches?
    return false if user_params[:password] == user_params[:confirmation]

    flash[:error] = 'Password and confirmation do not match'
    redirect_to '/register'
  end

  def non_unique_username?
    return false unless User.find_by(username: user_params[:username])

    flash[:error] = 'Username already exists'
    redirect_to '/register'
  end
end
