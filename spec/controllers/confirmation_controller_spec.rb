require 'rails_helper'

RSpec.describe ConfirmationController, type: :controller do
    let(:user) {create(:user)}
    let(:venue_record) { create(:venue_record, user: user, is_absence: nil) }
    let(:equipment_record) { create(:equipment_record, user: user, is_absence: nil, borrow_date: Date.current, expected_return_date: Date.tomorrow) }

    def sign_in(user)
        session[:user_id] = user.id
    end

    describe "user_authentication" do
        context "when user is not logged in" do
            it "redirects confirmation to login" do
                post :confirm, params: { type: "venue", id: venue_record.id }
                expect(response).to redirect_to(login_path)
            end
        end

       context "when user is logged in" do
            before{sign_in user}

            it "allow confirmation" do
                post :confirm, params: { type: "venue", id: venue_record.id }
                expect(response).to have_http_status(:redirect)
                expect(response).to redirect_to(confirmation_path)
            end
       end
    end

    describe "Confirm" do
        before{sign_in user}

        it "update venue record" do
            post :confirm, params: { type: "venue", id: venue_record.id }
            expect(venue_record.reload.is_absence).to be false
            expect(flash[:notice]).to eq("Venue attendance confirmed")
            expect(response).to redirect_to(confirmation_path)
        end

        
        it "successfully updates equipment record for pickup" do
            post :confirm, params: { 
                type: "equipment", 
                id: equipment_record.id, 
                action_type: "borrow" 
            }
            expect(equipment_record.reload.status).to eq("Borrowed")
            expect(equipment_record.reload.confirmed_borrow_at).to be_present
            expect(flash[:notice]).to include("Equipment pickup confirmed")
            expect(response).to redirect_to(confirmation_path)
        end
        
        it "successfully updates equipment record for return" do
            equipment_record.update(status: "Borrowed", confirmed_borrow_at: Time.current)
            
            post :confirm, params: { 
                type: "equipment", 
                id: equipment_record.id, 
                action_type: "return" 
            }
            expect(equipment_record.reload.status).to eq("Returned")
            expect(equipment_record.reload.confirmed_return_at).to be_present
            expect(flash[:notice]).to include("Equipment return confirmed")
            expect(response).to redirect_to(confirmation_path)
        end
    end
end