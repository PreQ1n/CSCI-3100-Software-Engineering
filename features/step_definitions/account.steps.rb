Given("I am logged in as a user") do 
    @current_user = User.create!(
        email: "student@gmail.com",
        password: "111"
    )

    visit login_path
    fill_in "Email", with: @current_user.email
    fill_in "Password", with: @current_user.password
    click_button "Login"
end

