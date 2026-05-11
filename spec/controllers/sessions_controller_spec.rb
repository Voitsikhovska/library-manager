require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  let(:user) { create(:user, password: 'password123') }

  describe 'GET #new' do
    context 'when user is not logged in' do
      it 'returns a successful response' do
        get :new
        expect(response).to be_successful
      end
    end

    context 'when user is already logged in' do
      before { login_user(user) }

      it 'redirects to root path' do
        get :new
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'POST #create' do
    context 'with valid credentials' do
      let(:valid_params) do
        {
          session: {
            email: user.email,
            password: 'password123'
          }
        }
      end

      it 'logs the user in' do
        post :create, params: valid_params
        expect(session[:user_id]).to eq(user.id)
      end

      it 'redirects to user show page' do
        post :create, params: valid_params
        expect(response).to redirect_to(user)
      end

      it 'sets a success notice' do
        post :create, params: valid_params
        expect(flash[:notice]).to match(/Logged in successfully/)
      end
    end

    context 'with invalid email' do
      let(:invalid_params) do
        {
          session: {
            email: 'wrong@example.com',
            password: 'password123'
          }
        }
      end

      it 'does not log the user in' do
        post :create, params: invalid_params
        expect(session[:user_id]).to be_nil
      end

      it 'renders the new template' do
        post :create, params: invalid_params
        expect(response).to render_template(:new)
      end

      it 'sets an alert message' do
        post :create, params: invalid_params
        expect(flash[:alert]).to match(/Invalid email or password/)
      end
    end

    context 'with invalid password' do
      let(:invalid_params) do
        {
          session: {
            email: user.email,
            password: 'wrongpassword'
          }
        }
      end

      it 'does not log the user in' do
        post :create, params: invalid_params
        expect(session[:user_id]).to be_nil
      end

      it 'renders the new template' do
        post :create, params: invalid_params
        expect(response).to render_template(:new)
      end
    end

    context 'when user is already logged in' do
      before { login_user(user) }

      it 'redirects to root path' do
        post :create, params: { session: { email: user.email, password: 'password123' } }
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'DELETE #destroy' do
    before { login_user(user) }

    it 'logs the user out' do
      delete :destroy
      expect(session[:user_id]).to be_nil
    end

    it 'redirects to root path' do
      delete :destroy
      expect(response).to redirect_to(root_path)
    end

    it 'sets a success notice' do
      delete :destroy
      expect(flash[:notice]).to match(/Logged out successfully/)
    end
  end
end

