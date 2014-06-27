require 'spec_helper'

feature "User unsubscribes from MyFlix" do
  
  scenario "user is deactivated", :vcr do
    jane = Fabricate(:user)
    customer = jane.customer_token
    Fabricate(:payment, reference_id: "12345", user_id: jane.id)
    sign_in_user(jane)
    visit billing_path
    click_link "Cancel Subscription"
    expect(page).to have_content("Your MyFlix subscription has been cancelled. We hope you will come back soon.")
    #expect(jane.deactivated).to be_true
  end
end