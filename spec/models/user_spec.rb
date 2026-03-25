require "rails_helper"

RSpec.describe User, type: :model do

    let(:user) { create(:user) } 

    describe "signup" do
    
        it "success with correct attribute" do
            expect(user).to be_valid
        end

        it "fail with null email" do
            user.email = nil
            expect(user).not_to be_valid
        end

        it "fail with null password" do
            user.password = nil
            expect(user).not_to be_valid
        end

        it "unique email" do
            user.save
            temp = user.dup
            expect(temp).not_to be_valid
        end

    end

    describe "login" do
    
        before do user.save end

        it "success with correct password" do
            temp = user.authenticate("123456")
            expect(temp).to eq(user)
        end

        it "fail with incorrect password" do
            temp = user.authenticate("12345")
            expect(temp).not_to eq(user)
        end

    end

end