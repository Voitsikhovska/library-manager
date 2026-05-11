require 'rails_helper'

RSpec.describe AuthorsController, type: :controller do
  let(:user) { create(:user) }
  let(:author) { create(:author) }

  describe 'GET #index' do
    let!(:author1) { create(:author) }
    let!(:author2) { create(:author) }

    it 'returns a successful response' do
      get :index
      expect(response).to be_successful
    end

    it 'assigns @authors' do
      get :index
      expect(assigns(:authors)).to match_array([ author1, author2 ])
    end
  end

  describe 'GET #show' do
    it 'returns a successful response' do
      get :show, params: { id: author.id }
      expect(response).to be_successful
    end

    it 'assigns the requested author to @author' do
      get :show, params: { id: author.id }
      expect(assigns(:author)).to eq(author)
    end

    it 'assigns the author books to @books' do
      book1 = create(:book, author: author)
      book2 = create(:book, author: author)
      get :show, params: { id: author.id }
      expect(assigns(:books)).to match_array([ book1, book2 ])
    end
  end

  describe 'GET #new' do
    context 'when user is logged in' do
      before { login_user(user) }

      it 'returns a successful response' do
        get :new
        expect(response).to be_successful
      end

      it 'assigns a new author to @author' do
        get :new
        expect(assigns(:author)).to be_a_new(Author)
      end
    end

    context 'when user is not logged in' do
      it 'redirects to login page' do
        get :new
        expect(response).to redirect_to(login_path)
      end
    end
  end

  describe 'POST #create' do
    context 'when user is logged in' do
      before { login_user(user) }

      context 'with valid parameters' do
        let(:valid_params) do
          {
            author: {
              name: 'New Author',
              bio: 'A great author',
              birth_year: 1975
            }
          }
        end

        it 'creates a new author' do
          expect {
            post :create, params: valid_params
          }.to change(Author, :count).by(1)
        end

        it 'redirects to the created author' do
          post :create, params: valid_params
          expect(response).to redirect_to(Author.last)
        end

        it 'sets a success notice' do
          post :create, params: valid_params
          expect(flash[:notice]).to match(/successfully created/)
        end
      end

      context 'with invalid parameters' do
        let(:invalid_params) do
          {
            author: {
              name: ''
            }
          }
        end

        it 'does not create a new author' do
          expect {
            post :create, params: invalid_params
          }.not_to change(Author, :count)
        end

        it 'renders the new template' do
          post :create, params: invalid_params
          expect(response).to render_template(:new)
        end
      end
    end

    context 'when user is not logged in' do
      it 'redirects to login page' do
        post :create, params: { author: { name: 'Test' } }
        expect(response).to redirect_to(login_path)
      end
    end
  end

  describe 'DELETE #destroy' do
    before { login_user(user) }

    it 'destroys the author' do
      author_to_delete = create(:author)
      expect {
        delete :destroy, params: { id: author_to_delete.id }
      }.to change(Author, :count).by(-1)
    end

    it 'destroys associated books' do
      author_with_books = create(:author, :with_books)
      expect {
        delete :destroy, params: { id: author_with_books.id }
      }.to change(Book, :count).by(-5)
    end

    it 'redirects to authors list' do
      delete :destroy, params: { id: author.id }
      expect(response).to redirect_to(authors_url)
    end

    it 'sets a success notice with book count' do
      author_with_books = create(:author, :with_books)
      delete :destroy, params: { id: author_with_books.id }
      expect(flash[:notice]).to match(/5 associated books/)
    end
  end

  describe 'POST #export' do
    let!(:author1) { create(:author) }
    let!(:author2) { create(:author) }

    context 'CSV export' do
      it 'returns CSV data' do
        post :export, params: { format: 'csv' }
        expect(response.content_type).to include('text/csv')
      end

      it 'sets the correct filename' do
        post :export, params: { format: 'csv' }
        expect(response.headers['Content-Disposition']).to include("authors_#{Date.today}.csv")
      end
    end

    context 'JSON export' do
      it 'returns JSON data' do
        post :export, params: { format: 'json' }
        expect(response.content_type).to include('application/json')
      end

      it 'sets the correct filename' do
        post :export, params: { format: 'json' }
        expect(response.headers['Content-Disposition']).to include("authors_#{Date.today}.json")
      end
    end

    context 'invalid format' do
      it 'redirects to authors path' do
        post :export, params: { format: 'xml' }
        expect(response).to redirect_to(authors_path)
      end

      it 'sets an alert message' do
        post :export, params: { format: 'xml' }
        expect(flash[:alert]).to match(/Invalid export format/)
      end
    end
  end
end
