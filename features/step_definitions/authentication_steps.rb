Given("the following user exists:") do |table|
    user_data = table.hashes.first

    @test_user = User.create!(
        email: user_data["email"],
        password: user_data["password"],
        faculty: user_data["faculty"],
        major: user_data["major"],
        college: user_data["college"]
    )
end

Given("I am not logged in") do
    visit(root_path)
    expect(page).to have_button("Login") 
end

Given("I am logged in") do
    step "I am on the login page"
    step 'I fill in the "Email" field with "student@gmail.com"'
    step 'I fill in the "Password" field with "111"'
    step 'I click the "Login" button'
end

When("I press the {string} button") do |button_name|
    click_on(button_name)
end

Then("I will navigate to the login page") do
    expect(page).to have_current_path(login_path)
end

Then("I should see the {string} header") do |header|
    expect(page).to have_selector('h1', text: header)
end

Then("I am logged out") do
    expect(page).to have_current_path(root_path)
    expect(page).to have_button("Login")
    expect(page).not_to have_button("Logout")
end

Given("I am on the login page") do
    visit(login_path)
end

When("I fill in the {string} field with {string}") do |field, value|
    fill_in(field, with: value)
end

When("I click the {string} button") do |button|
    click_button(button)
end

Then("I should see message {string}") do |msg|
    expect(page).to have_css('.flash-success', '.flash-error', text: msg)
end

Then("I should on the main page") do
    expect(page).to have_current_path(root_path)
end

Then("I should see a {string} button") do |button|
    expect(page).to have_button(button)
end







