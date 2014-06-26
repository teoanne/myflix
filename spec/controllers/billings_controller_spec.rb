require 'spec_helper'

describe BillingsController do
  
  describe "GET Unsubscribe" do
    let(:jane) { Fabricate(:user) }
    let(:payment) { Fabricate(:payment, user_id: jane.id, reference_id: "12345")}
    
    context 'logged in user' do
      
      before do
        customer = double('customer')
        customer.stub(:customer_token).and_return('abcdefg')
        StripeWrapper::Customer.should_receive(:retrieve).and_return(:customer_token)
        set_current_user(jane)
        get :unsubscribe, customer_token: jane.customer_token, reference_id: "12345"
      end

      it 'unsubscribes the user from the service' do
        expect(jane.unsubscribe).to be_true
      end

      it 'sets the @user instance variable' do
        expect(@user).to eq(jane)
      end

      it 'redirects the user to main page' do
        expect(response).to redirect_to home_path
      end

      it 'deactivates the account belonging to the user' do
        expect(User.deactivate?).to be_true
      end

      it 'sets the flash message confirming that the subscription has been cancelled' do
        expect(flash[:danger]).to be_present
      end
    end #ends context of logged in user
    
    context 'not logged in user' do
      
      let(:user) { Fabricate(:user, customer_token: "abcdefg") }
      let(:james) { Fabricate(:user, customer_token: "bcdefgh") }
      
      before do
        set_current_user(user)
      end
      
      it 'should redirect unauthenticated user to home path' do
        get :unsubscribe, customer_token: "bcdefgh"
        expect(response).to redirect_to home_path
      end
      
      it 'should display flash error message' do
        get :unsubscribe, customer_token: "bcdefgh"
        expect(flash[:danger]).to eq("You must be logged in to do that.")
      end
      
      it 'should not deactivate user' do
        get :unsubscribe, customer_token: "bcdefgh"
        expect(user.deactivated?).to be_false
      end
    end #ends context 'not logged in user'
  end #ends the GET Unsubscribe test
end