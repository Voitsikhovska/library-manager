class AuthorsController < ApplicationController
  before_action :require_login, except: [ :index, :show, :export ]
  before_action :set_author, only: [ :show, :edit, :update, :destroy ]

  def index
    @authors = AuthorSearchService.new(params).call

    # Apply sorting
    @authors = case params[:sort]
    when "name"
                 @authors.alphabetical
    else
                 @authors.alphabetical
    end
  end

  def show
    @books = @author.books
  end

  def new
    @author = Author.new
  end

  def create
    @author = current_user.authors.build(author_params)
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

  def export
    authors = AuthorSearchService.new(params).call
    export_format = params[:export_format] || params[:format]

    case export_format
    when "csv"
      send_data AuthorExportService.to_csv(authors),
                filename: "authors_#{Date.today}.csv",
                type: "text/csv; charset=utf-8",
                disposition: "attachment"
    when "json"
      send_data AuthorExportService.to_json(authors),
                filename: "authors_#{Date.today}.json",
                type: "application/json",
                disposition: "attachment"
    else
      redirect_to authors_path, alert: "Invalid export format"
    end
  end

  private

  def set_author
    @author = Author.find(params[:id])
  end

  def author_params
    params.require(:author).permit(:name, :bio, :birth_year)
  end

  def check_ownership
    unless @author.user == current_user
      redirect_to authors_path, alert: "You can only edit or delete authors you created"
    end
  end
end
