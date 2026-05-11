require 'rails_helper'

RSpec.describe 'Authentication', type: :request do
  let(:user) { create(:user, password: 'password123') }

  describe 'GET /login' do
    it 'returns a successful response' do
      get login_path
      expect(response).to have_http_status(:ok)
    end

    context 'when already logged in' do
      before { login_as(user) }

      it 'redirects to root' do
        get login_path
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'POST /login' do
    context 'with valid credentials' do
      it 'logs in the user' do
        post login_path, params: {
          session: {
            email: user.email,
            password: 'password123'
          }
        }
        expect(response).to redirect_to(user_path(user))
        follow_redirect!
        expect(response.body).to include('Logged in successfully')
      end
    end

    context 'with invalid credentials' do
      it 'does not log in the user' do
        post login_path, params: {
          session: {
            email: user.email,
            password: 'wrongpassword'
          }
        }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include('Invalid email or password')
      end
    end
  end

  describe 'DELETE /logout' do
    before { login_as(user) }

    it 'logs out the user' do
      delete logout_path
      expect(response).to redirect_to(root_path)
      follow_redirect!
      expect(response.body).to include('Logged out successfully')
    end
  end

  describe 'GET /signup' do
    it 'returns a successful response' do
      get signup_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST /signup' do
    context 'with valid parameters' do
      let(:valid_params) do
        {
          user: {
            name: 'New User',
            email: 'newuser@example.com',
            password: 'password123',
            password_confirmation: 'password123'
          }
        }
      end

      it 'creates a new user' do
        expect {
          post signup_path, params: valid_params
        }.to change(User, :count).by(1)
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) do
        {
          user: {
            name: '',
            email: 'invalid',
            password: 'short'
          }
        }
      end

      it 'does not create a user' do
        expect {
          post signup_path, params: invalid_params
        }.not_to change(User, :count)
      end
    end
  end
end

