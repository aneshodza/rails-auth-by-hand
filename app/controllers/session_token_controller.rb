class SessionTokenController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.find_by(username: user_params[:username])
    return if invalid_login?

    cookies[:session_token] = "#{@user.id};#{generate_session_token}"
    manage_session_token

    flash[:success] = 'Login successful'
    redirect_to '/account'
  end

  def destroy
    unless cookies[:session_token]
      flash[:error] = 'You are not logged in'
      redirect_to '/login'
      return
    end
    ManualSessionToken.where(key: cookies[:session_token].split(';')[1]).destroy_all
    cookies.delete(:session_token)
    flash[:success] = 'Logout successful'
    redirect_to root_path
  end

  private

  def user_params
    params.require(:user).permit(:username, :password)
  end

  def invalid_login?
    if @user && @user.password == Digest::SHA256.hexdigest(user_params[:password] + @user.salt + User::PEPPER)
      return false
    end

    flash[:error] = 'Invalid login :/'
    redirect_to '/login'
  end

  def generate_session_token
    SecureRandom.hex(64)
  end

  def manage_session_token
    session_token = ManualSessionToken.where(user_id: @user.id).first
    if session_token
      session_token.update(key: cookies[:session_token])
    else
      ManualSessionToken.create(user_id: @user.id, key: cookies[:session_token])
    end
  end
end
