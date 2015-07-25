require 'rails_helper'

feature 'endorsing reviews' do
  before do
    kfc = Restaurant.create(name: 'KFC')
    kfc.reviews.create(rating: 3, thoughts: 'It was an abomination')
  end

  scenario 'no endorsements' do
    visit '/restaurants'
    expect(page).to have_content('0 endorsements')
  end

  scenario 'a user can endorse a review, which updates the review endorsement count', js:true do
    visit '/restaurants'
    click_link 'Endorse Review' #are we endorsing restaurants or the review of the restaurants?
    expect(page).to have_content('1 endorsement')
  end

end