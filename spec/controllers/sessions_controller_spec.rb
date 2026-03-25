require "rails_helper"

RSpec.describe SessionsController, type: :controller do 

    describe "new" do

        it "render the login page" do
        get :new
        expect(response).to render_template(:new)
        end

    end

    let(:testing_params) {{email: "testing1234@gmail.com", password: "123456"}}
    let(:testing_params_2) {{email: "testing134@gmail.com", password: "123456"}}
    let(:testing_params_3) {{email: "testing1234@gmail.com", password: "12456"}}
    let!(:user) { create(:user) } 

    describe "create" do

        it "logs in with valid params" do
            post :create, params: testing_params
            expect(session[:user_id]).to eq(user.id)
            expect(response).to redirect_to(root_path)
        end

        it "logs in with invalid email" do
            post :create, params: testing_params_2
            expect(session[:user_id]).to eq(nil)
            expect(response).to render_template(:new)
            expect(flash.now[:alert]).to eq("Invalid Email or Password") 
        end

        it "logs in with invalid password" do
            post :create, params: testing_params_3
            expect(session[:user_id]).to eq(nil)
            expect(response).to render_template(:new)
            expect(flash.now[:alert]).to eq("Invalid Email or Password") 
        end
    end

    describe "destroy" do

        before do 
            post :create, params: testing_params
        end

        it "logs out the user" do
            delete :destroy
            expect(session[:user_id]).to eq(nil)
            expect(response).to redirect_to(root_path)
        end
    end
end