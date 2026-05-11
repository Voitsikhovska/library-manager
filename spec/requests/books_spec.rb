require 'rails_helper'

RSpec.describe 'Books', type: :request do
  let(:user) { create(:user) }
  let(:author) { create(:author) }

  describe 'GET /books' do
    let!(:book1) { create(:book) }
    let!(:book2) { create(:book) }

    it 'returns a successful response' do
      get books_path
      expect(response).to have_http_status(:ok)
    end

    it 'displays all books' do
      get books_path
      expect(response.body).to include(book1.title)
      expect(response.body).to include(book2.title)
    end

    context 'with search parameters' do
      it 'filters books by search term' do
        book = create(:book, title: 'Unique Book Title')
        get books_path, params: { search: 'Unique' }
        expect(response.body).to include('Unique Book Title')
      end
    end

    context 'with pagination' do
      before do
        create_list(:book, 15)
      end

      it 'displays paginated results' do
        get books_path
        expect(response).to have_http_status(:ok)
      end

      it 'displays correct page' do
        get books_path, params: { page: 2 }
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'GET /books/:id' do
    let(:book) { create(:book) }

    it 'returns a successful response' do
      get book_path(book)
      expect(response).to have_http_status(:ok)
    end

    it 'displays book details' do
      get book_path(book)
      expect(response.body).to include(book.title)
      expect(response.body).to include(book.description)
    end
  end

  describe 'GET /books/new' do
    context 'when logged in' do
      before { login_as(user) }

      it 'returns a successful response' do
        get new_book_path
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when not logged in' do
      it 'redirects to login' do
        get new_book_path
        expect(response).to redirect_to(login_path)
      end
    end
  end

  describe 'POST /books' do
    context 'when logged in' do
      before { login_as(user) }

      context 'with valid parameters' do
        let(:valid_params) do
          {
            book: {
              title: 'New Book',
              description: 'Great book',
              isbn: 'ISBN-123-NEW',
              published_year: 2020,
              author_id: author.id
            }
          }
        end

        it 'creates a new book' do
          expect {
            post books_path, params: valid_params
          }.to change(Book, :count).by(1)
        end

        it 'redirects to the created book' do
          post books_path, params: valid_params
          expect(response).to redirect_to(book_path(Book.last))
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

        it 'does not create a book' do
          expect {
            post books_path, params: invalid_params
          }.not_to change(Book, :count)
        end

        it 'returns unprocessable entity status' do
          post books_path, params: invalid_params
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    context 'when not logged in' do
      it 'redirects to login' do
        post books_path, params: { book: { title: 'Test' } }
        expect(response).to redirect_to(login_path)
      end
    end
  end

  describe 'PATCH /books/:id' do
    let(:book) { create(:book, user: user) }

    context 'when logged in as owner' do
      before { login_as(user) }

      context 'with valid parameters' do
        it 'updates the book' do
          patch book_path(book), params: { book: { title: 'Updated Title' } }
          book.reload
          expect(book.title).to eq('Updated Title')
        end

        it 'redirects to the book' do
          patch book_path(book), params: { book: { title: 'Updated Title' } }
          expect(response).to redirect_to(book_path(book))
        end
      end

      context 'with invalid parameters' do
        it 'does not update the book' do
          original_title = book.title
          patch book_path(book), params: { book: { title: '' } }
          book.reload
          expect(book.title).to eq(original_title)
        end
      end
    end

    context 'when logged in as different user' do
      let(:other_user) { create(:user) }
      before { login_as(other_user) }

      it 'redirects to books path' do
        patch book_path(book), params: { book: { title: 'Updated' } }
        expect(response).to redirect_to(books_path)
      end
    end
  end

  describe 'DELETE /books/:id' do
    let(:book) { create(:book, user: user) }

    context 'when logged in as owner' do
      before { login_as(user) }

      it 'deletes the book' do
        book # create the book first
        expect {
          delete book_path(book)
        }.to change(Book, :count).by(-1)
      end

      it 'redirects to books index' do
        delete book_path(book)
        expect(response).to redirect_to(books_path)
      end
    end

    context 'when logged in as different user' do
      let(:other_user) { create(:user) }
      before { login_as(other_user) }

      it 'does not delete the book' do
        book # create the book first
        expect {
          delete book_path(book)
        }.not_to change(Book, :count)
      end
    end
  end

  describe 'POST /books/export' do
    let!(:book1) { create(:book) }
    let!(:book2) { create(:book) }

    context 'CSV export' do
      it 'returns CSV data' do
        post export_books_path(format: 'csv')
        expect(response.content_type).to include('text/csv')
      end
    end

    context 'JSON export' do
      it 'returns JSON data' do
        post export_books_path(format: 'json')
        expect(response.content_type).to include('application/json')
      end
    end
  end
end

