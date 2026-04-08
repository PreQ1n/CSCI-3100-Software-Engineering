class UsersController < ApplicationController
    
    def new
    end

    def create
        @user = User.new(
            email: params[:email],
            password: params[:password],
            password_confirmation: params[:password_confirmation],
        )

        if @user.save
            session[:user_id] = @user.id
            flash[:notice] = "Account Created"
            redirect_to root_path
        else
            if @user.errors[:email].include?("has already been taken")
                flash[:alert] = "Account already exists."
            else 
                flash[:alert] = "Account Creation Fail. Plase try again"
            end
            render :new, status: :unprocessable_entity
        end
    end

end