require 'spec_helper'
include ApplicationHelper

describe "Static pages" do

  subject { page }

  shared_examples_for "all static pages" do
    it { should have_selector('h1',    text: heading) }
    it { should have_selector('title', text: full_title(page_title)) }
  end

  describe "Home page" do
    before { visit root_path }
    let(:heading)      { 'Sample App'}
    let(:page_title)   { '' }
    
    it_should_behave_like "all static pages"
    it { should_not have_selector 'title', text: '| Home' }
  end

  describe "Help page" do
    before { visit help_path }
    let(:heading)      {'Help' }
    let(:page_title)   {'Help'}

    it_should_behave_like "all static pages"
  end

  describe "About page" do
    before { visit about_path }
    let(:heading)      {'About'}
    let(:page_title)   {'About Us'}

    it_should_behave_like "all static pages"
  end

  describe "Contact page" do
    before { visit contact_path }
    let(:heading)      {'Contact'}
    let(:page_title)   {'Contact'}

    it_should_behave_like "all static pages"
  end

  it "should have the right links on the layout" do
    visit root_path
    click_link "About"
    page.should have_selector 'title', text: full_title('About Us')
    click_link "Help"
    page.should have_selector 'title', text: full_title('Help')
    click_link "Contact"
    page.should have_selector 'title',  text: full_title('Contact')
    click_link "Home"
    click_link "Sign up now!"
    page.should have_selector 'title', text: full_title('Sign up')
  end

  describe "for signed-in users" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      FactoryGirl.create(:micropost, user: user, content: "Lorem Ipsum")
      FactoryGirl.create(:micropost, user: user, content: "Dolor sit amet")
      sign_in user
      visit root_path
    end
    it "should render the user's feed" do
      user.feed.each do |item|
        page.should have_selector("li##{item.id}", text: item.content) 
      end
    end
    it "should show pluralized micropost count for more than 1 micropost" do
      regexp = /2 microposts$/
      page.should have_selector('span', text: regexp)
    end   
  end

  describe "Micropost Counts and Pagination for single post" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      FactoryGirl.create(:micropost, user: user, content: "Lorem Ipsum")
      sign_in user
      visit root_path  end

    it "should show singular micropost for 1 micropost" do
      regexp = /1 micropost$/
      page.should have_selector('span', text: regexp) 
    end
  end

  describe "Micropost Counts and Pagination for multi page post" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      30.times { FactoryGirl.create(:micropost, user: user, content: "Lorem Ipsume") }
      sign_in user
      visit root_path
    end
    it "should have pagination" do
      page.should have_selector('div.pagination')
      
    end
  end
  

end