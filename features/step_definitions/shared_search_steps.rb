# features/step_definitions/shared_steps.rb

When("I search for {string}") do |search_term|
    # This works for both Venues and Equipment because both forms use name="query"
    fill_in "query", with: search_term
    sleep 0.5 # Wait for Stimulus debounce
  end
  
  Then("I should see {string}") do |text|
    expect(page).to have_content(text)
  end
  
  Then("I should not see {string}") do |text|
    expect(page).to have_no_content(text)
  end
  
  When("I follow {string}") do |link_text|
    click_link link_text
  end