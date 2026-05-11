require 'rails_helper'

RSpec.describe BooksController, type: :controller do
  let(:user) { create(:user) }
  let(:author) { create(:author) }
  let(:book) { create(:book, user: user, author: author) }
  let(:other_user) { create(:user) }

  describe 'GET #index' do
    let!(:book1) { create(:book, user: user) }
    let!(:book2) { create(:book, user: user) }

    it 'returns a successful response' do
      get :index
      expect(response).to be_successful
    end

    it 'assigns @books' do
      get :index
      expect(assigns(:books)).to match_array([ book1, book2 ])
    end

    it 'assigns @authors' do
      get :index
      expect(assigns(:authors)).to include(book1.author, book2.author)
    end
  end

  describe 'GET #show' do
    it 'returns a successful response' do
      get :show, params: { id: book.id }
      expect(response).to be_successful
    end

    it 'assigns the requested book to @book' do
      get :show, params: { id: book.id }
      expect(assigns(:book)).to eq(book)
    end
  end

  describe 'GET #new' do
    context 'when user is logged in' do
      before { login_user(user) }

      it 'returns a successful response' do
        get :new
        expect(response).to be_successful
      end

      it 'assigns a new book to @book' do
        get :new
        expect(assigns(:book)).to be_a_new(Book)
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
            book: {
              title: 'New Book',
              description: 'A great book',
              isbn: 'ISBN-NEW-123',
              published_year: 2020,
              author_id: author.id
            }
          }
        end

        it 'creates a new book' do
          expect {
            post :create, params: valid_params
          }.to change(Book, :count).by(1)
        end

        it 'associates the book with the current user' do
          post :create, params: valid_params
          expect(Book.last.user).to eq(user)
        end

        it 'redirects to the created book' do
          post :create, params: valid_params
          expect(response).to redirect_to(Book.last)
        end

        it 'sets a success notice' do
          post :create, params: valid_params
          expect(flash[:notice]).to match(/successfully created/)
        end
      end

      context 'with invalid parameters' do
        let(:invalid_params) do
          {
            book: {
              title: '',
              isbn: ''
            }
          }
        end

        it 'does not create a new book' do
          expect {
            post :create, params: invalid_params
          }.not_to change(Book, :count)
        end

        it 'renders the new template' do
          post :create, params: invalid_params
          expect(response).to render_template(:new)
        end
      end
    end

    context 'when user is not logged in' do
      it 'redirects to login page' do
        post :create, params: { book: { title: 'Test' } }
        expect(response).to redirect_to(login_path)
      end
    end
  end

  describe 'GET #edit' do
    context 'when user is logged in and owns the book' do
      before { login_user(user) }

      it 'returns a successful response' do
        get :edit, params: { id: book.id }
        expect(response).to be_successful
      end

      it 'assigns the requested book to @book' do
        get :edit, params: { id: book.id }
        expect(assigns(:book)).to eq(book)
      end
    end

    context 'when user does not own the book' do
      let(:other_book) { create(:book, user: other_user) }
      before { login_user(user) }

      it 'redirects to books path' do
        get :edit, params: { id: other_book.id }
        expect(response).to redirect_to(books_path)
      end

      it 'sets an alert message' do
        get :edit, params: { id: other_book.id }
        expect(flash[:alert]).to match(/Not authorized/)
      end
    end

    context 'when user is not logged in' do
      it 'redirects to login page' do
        get :edit, params: { id: book.id }
        expect(response).to redirect_to(login_path)
      end
    end
  end

  describe 'PATCH #update' do
    context 'when user owns the book' do
      before { login_user(user) }

      context 'with valid parameters' do
        let(:new_attributes) { { title: 'Updated Title' } }

        it 'updates the book' do
          patch :update, params: { id: book.id, book: new_attributes }
          book.reload
          expect(book.title).to eq('Updated Title')
        end

        it 'redirects to the book' do
          patch :update, params: { id: book.id, book: new_attributes }
          expect(response).to redirect_to(book)
        end
      end

      context 'with invalid parameters' do
        let(:invalid_attributes) { { title: '' } }

        it 'does not update the book' do
          original_title = book.title
          patch :update, params: { id: book.id, book: invalid_attributes }
          book.reload
          expect(book.title).to eq(original_title)
        end

        it 'renders the edit template' do
          patch :update, params: { id: book.id, book: invalid_attributes }
          expect(response).to render_template(:edit)
        end
      end
    end

    context 'when user does not own the book' do
      let(:other_book) { create(:book, user: other_user) }
      before { login_user(user) }

      it 'does not update the book' do
        original_title = other_book.title
        patch :update, params: { id: other_book.id, book: { title: 'New Title' } }
        other_book.reload
        expect(other_book.title).to eq(original_title)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when user owns the book' do
      before { login_user(user) }

      it 'destroys the book' do
        book_to_delete = create(:book, user: user)
        expect {
          delete :destroy, params: { id: book_to_delete.id }
        }.to change(Book, :count).by(-1)
      end

      it 'redirects to books list' do
        delete :destroy, params: { id: book.id }
        expect(response).to redirect_to(books_url)
      end

      it 'sets a success notice' do
        delete :destroy, params: { id: book.id }
        expect(flash[:notice]).to match(/successfully deleted/)
      end
    end

    context 'when user does not own the book' do
      before { login_user(user) }

      it 'does not destroy the book' do
        other_book = create(:book, user: other_user)
        expect {
          delete :destroy, params: { id: other_book.id }
        }.not_to change(Book, :count)
      end
    end
  end

  describe 'POST #export' do
    let!(:book1) { create(:book, user: user) }
    let!(:book2) { create(:book, user: user) }

    context 'CSV export' do
      it 'returns CSV data' do
        post :export, params: { format: 'csv' }
        expect(response.content_type).to include('text/csv')
      end

      it 'sets the correct filename' do
        post :export, params: { format: 'csv' }
        expect(response.headers['Content-Disposition']).to include("books_#{Date.today}.csv")
      end
    end

    context 'JSON export' do
      it 'returns JSON data' do
        post :export, params: { format: 'json' }
        expect(response.content_type).to include('application/json')
      end

      it 'sets the correct filename' do
        post :export, params: { format: 'json' }
        expect(response.headers['Content-Disposition']).to include("books_#{Date.today}.json")
      end
    end

    context 'invalid format' do
      it 'redirects to books path' do
        post :export, params: { format: 'pdf' }
        expect(response).to redirect_to(books_path)
      end

      it 'sets an alert message' do
        post :export, params: { format: 'pdf' }
        expect(flash[:alert]).to match(/Invalid export format/)
      end
    end
  end
end
