class AuthorsController < ApplicationController
  before_action :require_login, except: [ :index, :show ]
  before_action :set_author, only: [ :show, :edit, :update, :destroy ]

  def index
    @authors = if params[:search].present?
                 Author.where("name ILIKE ? OR bio ILIKE ?", "%#{params[:search]}%", "%#{params[:search]}%")
    else
                 Author.all
    end
  end

  def show
    @books = @author.books
  end

  def new
    @author = Author.new
  end

  def create
    @author = Author.new(author_params)
    if @author.save
      redirect_to @author, notice: "Author was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @author.update(author_params)
      redirect_to @author, notice: "Author was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    name = @author.name
    book_count = @author.books.count
    @author.destroy
    redirect_to authors_url, notice: "Author '#{name}' and #{book_count} associated books were successfully deleted."
  end

  private

  def set_author
    @author = Author.find(params[:id])
  end

  def author_params
    params.require(:author).permit(:name, :bio, :birth_year)
  end
end
