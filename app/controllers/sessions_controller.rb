class SessionsController < ApplicationController
  
  def new
    redirect_to home_path if current_user
  end
  
  def create
    user = User.where(email: params[:email]).first
    
    if user && user.authenticate(params[:password])
      if user.active?
        session[:user_id] = user.id
        flash[:success] = current_user.admin? ? "Welcome to the admin page" : "You are signed in, enjoy your movies!"
        redirect_to current_user.admin? ? new_admin_video_path : home_path 
      else
        flash[:danger] = "Your account is no longer active. Please contact us."
        redirect_to login_path
      end
    else
      flash[:danger] = "There is something wrong with your email or password."
      redirect_to login_path
    end
  end
  
  def destroy
    session[:user_id] = nil
    flash[:danger] = "You have been signed out."
    redirect_to root_path
  end
  
end