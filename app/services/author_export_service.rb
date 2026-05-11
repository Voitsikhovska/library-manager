require "csv"

class AuthorExportService < BaseExportService
  def self.csv_headers
    [ "Name", "Birth Year", "Bio", "Total Books", "Created At" ]
  end

  def self.csv_row(author)
    [
      author.name,
      author.birth_year,
      author.bio,
      author.books.count,
      author.created_at.strftime("%Y-%m-%d")
    ]
  end

  def self.json_record(author)
    {
      id: author.id,
      name: author.name,
      birth_year: author.birth_year,
      bio: author.bio,
      books_count: author.books.count,
      books: author.books.map { |book| { id: book.id, title: book.title, isbn: book.isbn } },
      created_at: author.created_at.iso8601,
      updated_at: author.updated_at.iso8601
    }
  end
end
