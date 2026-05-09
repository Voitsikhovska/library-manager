class BooksController < ApplicationController
  before_action :require_login, except: [ :index, :show ]
  before_action :set_book, only: [ :show, :edit, :update, :destroy ]
  before_action :check_ownership, only: [ :edit, :update, :destroy ]

  def index
    @books = BookSearchService.new(params).call

    # Apply sorting
    @books = case params[:sort]
    when "title_asc"
               @books.alphabetical
    when "recent"
               @books.recent
    else
               @books.recent
    end

    @authors = Author.alphabetical
  end

  def show
  end

  def new
    @book = Book.new
  end

  def create
    @book = current_user.books.build(book_params)
    if @book.save
      redirect_to @book, notice: "Book was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @book.update(book_params)
      redirect_to @book, notice: "Book was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    title = @book.title
    @book.destroy
    redirect_to books_url, notice: "Book '#{title}' was successfully deleted."
  end

  private

  def set_book
    @book = Book.find(params[:id])
  end

  def check_ownership
    redirect_to books_path, alert: "Not authorized" unless @book.user == current_user
  end

  def book_params
    params.require(:book).permit(:title, :description, :isbn, :published_year, :author_id)
  end
end
