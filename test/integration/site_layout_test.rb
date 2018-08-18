require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

   test "layout links" do
     get root_path
     assert_template "static_pages/home"
     assert_select "a[href=?]", root_path, count: 2
     assert_select "a[href=?]", help_path
     assert_select "a[href=?]", about_path
     assert_select "a[href=?]", contact_path
     get contact_path
     assert_select "title", full_title("Contact")
     get signup_path
     assert_select "title", full_title("Sign up")
   end

   test "should show correct links" do
     get root_path
     assert_select "a[href=?]", users_path, count: 0
     assert_select "a.dropdown-toggle", count: 0
     assert_select "a[href=?]", user_path(@user), count:0
     assert_select "a[href=?]", edit_user_path(@user), count:0
     assert_select "a[href=?]", logout_path, count:0
     assert_select "a[href=?]", login_path
     log_in_as(@user)
     get root_path
     assert_select "a[href=?]", users_path
     assert_select "a.dropdown-toggle"
     assert_select "a[href=?]", user_path(@user)
     assert_select "a[href=?]", edit_user_path(@user)
     assert_select "a[href=?]", logout_path
     assert_select "a[href=?]", login_path, count:0
   end

   test "count relationship" do
     log_in_as(@user)
     get root_path
     assert_select "strong#following", text: @user.following.count.to_s
     assert_select "strong#followers", text: @user.followers.count.to_s
   end
end
