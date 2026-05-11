class BookSearchService
  def initialize(params = {})
    @search = params[:search]
    @author_id = params[:author_id]
    @year_from = params[:year_from]
    @year_to = params[:year_to]
    @user_id = params[:user_id]
  end

  def call
    relation = Book.all

    relation = filter_by_user(relation) if @user_id.present?
    relation = filter_by_search(relation) if @search.present?
    relation = filter_by_author(relation) if @author_id.present?
    relation = filter_by_year_range(relation) if @year_from.present? || @year_to.present?

    relation
  end

  private

  def filter_by_user(relation)
    relation.where(user_id: @user_id)
  end

  def filter_by_search(relation)
    relation.where("title ILIKE ? OR description ILIKE ? OR isbn ILIKE ?",
                   "%#{@search}%", "%#{@search}%", "%#{@search}%")
  end

  def filter_by_author(relation)
    relation.where(author_id: @author_id)
  end

  def filter_by_year_range(relation)
    if @year_from.present? && @year_to.present?
      relation.where(published_year: @year_from..@year_to)
    elsif @year_from.present?
      relation.where("published_year >= ?", @year_from)
    elsif @year_to.present?
      relation.where("published_year <= ?", @year_to)
    else
      relation
    end
  end
end
