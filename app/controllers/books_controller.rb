class BooksController < ApplicationController
  before_action :require_login, except: [ :index, :show, :export ]
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

    # No pagination - show all books
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

  def export
    books = BookSearchService.new(params).call
    export_format = params[:export_format] || params[:format]

    case export_format
    when "csv"
      send_data BookExportService.to_csv(books),
                filename: "books_#{Date.today}.csv",
                type: "text/csv; charset=utf-8",
                disposition: "attachment"
    when "json"
      send_data BookExportService.to_json(books),
                filename: "books_#{Date.today}.json",
                type: "application/json",
                disposition: "attachment"
    else
      redirect_to books_path, alert: "Invalid export format"
    end
  end

  private

  def set_book
    @book = Book.find(params[:id])
  end

  def check_ownership
    check_resource_ownership(@book, books_path, "Not authorized")
  end

  def book_params
    params.require(:book).permit(:title, :description, :isbn, :published_year, :author_id)
  end
end
