require File.dirname(__FILE__) + '/../test_helper'
require 'admins_controller'

# Re-raise errors caught by the controller.
class AdminsController; def rescue_action(e) raise e end; end

class AdminsControllerTest < ActionController::TestCase
  # Be sure to include AuthenticatedTestHelper in test/test_helper.rb instead
  # Then, you can remove it from this and the units test.
  include AuthenticatedTestHelper

  fixtures :admins

  def test_should_allow_signup
    assert_difference 'Admin.count' do
      create_admin
      assert_response :redirect
    end
  end

  def test_should_require_login_on_signup
    assert_no_difference 'Admin.count' do
      create_admin(:login => nil)
      assert assigns(:admin).errors.on(:login)
      assert_response :success
    end
  end

  def test_should_require_password_on_signup
    assert_no_difference 'Admin.count' do
      create_admin(:password => nil)
      assert assigns(:admin).errors.on(:password)
      assert_response :success
    end
  end

  def test_should_require_password_confirmation_on_signup
    assert_no_difference 'Admin.count' do
      create_admin(:password_confirmation => nil)
      assert assigns(:admin).errors.on(:password_confirmation)
      assert_response :success
    end
  end

  def test_should_require_email_on_signup
    assert_no_difference 'Admin.count' do
      create_admin(:email => nil)
      assert assigns(:admin).errors.on(:email)
      assert_response :success
    end
  end
  

  
  def test_should_sign_up_user_with_activation_code
    create_admin
    assigns(:admin).reload
    assert_not_nil assigns(:admin).activation_code
  end

  def test_should_activate_user
    assert_nil Admin.authenticate('aaron', 'test')
    get :activate, :activation_code => admins(:aaron).activation_code
    assert_redirected_to '/login'
    assert_not_nil flash[:notice]
    assert_equal admins(:aaron), Admin.authenticate('aaron', 'monkey')
  end
  
  def test_should_not_activate_user_without_key
    get :activate
    assert_nil flash[:notice]
  rescue ActionController::RoutingError
    # in the event your routes deny this, we'll just bow out gracefully.
  end

  def test_should_not_activate_user_with_blank_key
    get :activate, :activation_code => ''
    assert_nil flash[:notice]
  rescue ActionController::RoutingError
    # well played, sir
  end

  protected
    def create_admin(options = {})
      post :create, :admin => { :login => 'quire', :email => 'quire@example.com',
        :password => 'quire69', :password_confirmation => 'quire69' }.merge(options)
    end
end
