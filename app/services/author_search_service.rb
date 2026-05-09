class AuthorSearchService
  def initialize(params = {})
    @search = params[:search]
    @birth_year_from = params[:birth_year_from]
    @birth_year_to = params[:birth_year_to]
  end

  def call
    relation = Author.all

    relation = filter_by_search(relation) if @search.present?
    relation = filter_by_birth_year_range(relation) if @birth_year_from.present? || @birth_year_to.present?

    relation
  end

  private

  def filter_by_search(relation)
    relation.where("name ILIKE ? OR bio ILIKE ?",
                   "%#{@search}%", "%#{@search}%")
  end

  def filter_by_birth_year_range(relation)
    if @birth_year_from.present? && @birth_year_to.present?
      relation.where(birth_year: @birth_year_from..@birth_year_to)
    elsif @birth_year_from.present?
      relation.where("birth_year >= ?", @birth_year_from)
    elsif @birth_year_to.present?
      relation.where("birth_year <= ?", @birth_year_to)
    else
      relation
    end
  end
end
