module AuthenticationHelpers
  # For controller tests
  def login_user(user = nil)
    user ||= create(:user)
    session[:user_id] = user.id
    user
  end

  def logout_user
    session.delete(:user_id)
  end

  # For request/integration tests
  def login_as(user)
    post login_path, params: {
      session: {
        email: user.email,
        password: user.password || "password123"
      }
    }
  end

  def logout
    delete logout_path
  end
end

RSpec.configure do |config|
  config.include AuthenticationHelpers, type: :controller
  config.include AuthenticationHelpers, type: :request
  config.include AuthenticationHelpers, type: :feature
end
