module AuthenticatedTestHelper
  # Sets the current admin in the session from the admin fixtures.
  def login_as(admin)
    @request.session[:admin_id] = admin ? admins(admin).id : nil
  end

  def authorize_as(user)
    @request.env["HTTP_AUTHORIZATION"] = user ? ActionController::HttpAuthentication::Basic.encode_credentials(users(user).login, 'test') : nil
  end
end
