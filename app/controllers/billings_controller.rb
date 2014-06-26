class BillingsController < ApplicationController
  before_filter :require_user
  before_filter :find_user
  
  def unsubscribe
    Stripe.api_key = ENV['STRIPE_SECRET_KEY']
    customer = Stripe::Customer.retrieve(@user.customer_token)
    customer.subscriptions.retrieve(@user.payments.last.reference_id).delete #to retrieve the latest payment
    @user.unsubscribe
    # add an AppMailer
    flash[:danger] = "Your MyFlix subscription has been cancelled. We hope you will come back soon."
    redirect_to home_path
  end
  
  private
  
  def find_user
    @user = User.find(params[:id])
  end
  
end