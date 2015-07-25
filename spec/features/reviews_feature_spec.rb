require 'rails_helper'

feature 'reviewing' do

  before {Restaurant.create name: 'KFC'}

  scenario 'allows users to leave a review using a form' do
    visit '/restaurants'
    click_link 'Review KFC'
    fill_in "Thoughts", with: "so so"
    select '3', from: 'Rating'
    click_button 'Leave Review'

    expect(current_path).to eq '/restaurants'
    expect(page).to have_content('so so')
  end

  context 'deleting reviews' do
    before do
      user = User.create email: 'tansaku@gmail.com', password: '12345678', password_confirmation: '12345678'
      login_as user
      visit '/restaurants'
      click_link 'Review KFC'
      fill_in "Thoughts", with: "so so"
      select '3', from: 'Rating'
      click_button 'Leave Review'
    end

    scenario 'allows owner to delete own review' do
      visit '/restaurants'
      click_link 'Delete Review'
      expect(page).to_not have_content('so so')
    end
  end
end