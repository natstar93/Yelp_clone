require 'rails_helper'

feature 'reviewing' do

  before {Restaurant.create name: 'KFC'}

  context 'leaving a review' do
    scenario 'when logged in' do
      user = User.create email: 'tansaku@gmail.com', password: '12345678', password_confirmation: '12345678'
      login_as user
      visit '/restaurants'
      click_link 'Review KFC'
      fill_in "Thoughts", with: "so so"
      select '3', from: 'Rating'
      click_button 'Leave Review'

      expect(current_path).to eq '/restaurants'
      expect(page).to have_content('so so')
    end

    scenario 'when not logged in' do
      visit '/restaurants'
      click_link 'Review KFC'
      expect(page).to have_content('You need to sign in or sign up before continuing')
    end
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

  def leave_review(thoughts, rating)
    visit '/restaurants'
    click_link 'Review KFC'
    fill_in 'Thoughts', with: thoughts
    select rating, from: 'Rating'
    click_button 'Leave Review'
  end

  scenario 'displays an average rating for all reviews' do
    user = User.create email: 'tansaku@gmail.com', password: '12345678', password_confirmation: '12345678'
    login_as user
    leave_review('So so', '3')
    user_2 = User.create email: 'tansau@gmail.com', password: '12345678', password_confirmation: '12345678'
    login_as user_2
    leave_review('Great', '5')
    expect(page).to have_content('Average rating: 4')
  end
end