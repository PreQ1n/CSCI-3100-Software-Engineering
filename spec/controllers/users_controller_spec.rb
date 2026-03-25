require 'rails_helper'

RSpec.describe UsersController, type: :controller do

    describe "#new" do

        it "render the signup page" do
            get :new
            expect(response).to render_template(:new)
        end

    end

    describe "#create" do

        let(:testing_params) {{email: "testing1234@gmail.com", password: "123456", password_confirmation: "123456"}}
        let(:testing_params_2) {{email: nil , password: "123456", password_confirmation: "123456"}}

        it "creates a new user" do
            expect { post :create, params: testing_params}.to change(User, :count).by(1)
        end

        it "if create success, redirect to root and have success msg" do
            post :create, params: testing_params
            expect(response).to redirect_to(root_path)
            expect(flash[:notice]).to eq("Account Created")
        end

        it "fail to create a new user" do
            create(:user, email:"testing1234@gmail.com")
            expect { post :create, params: testing_params}.to change(User, :count).by(0)
        end

        it "fail to create a new user by same " do
            create(:user, email:"testing1234@gmail.com")
            post :create, params: testing_params
            expect(response).to render_template(:new)
            expect(flash.now[:alert]).to eq("Account already exists.")
        end

        it "fail to create a new user by nil" do
            post :create, params: testing_params_2
            expect(response).to render_template(:new)
            expect(flash.now[:alert]).to eq("Account Creation Fail. Plase try again")
        end

    end

end