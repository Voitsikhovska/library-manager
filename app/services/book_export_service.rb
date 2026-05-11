require "csv"

# Inherits shared to_csv and to_json logic from BaseExportService.
# Only defines what is specific to books.
class BookExportService < BaseExportService
  def self.csv_headers
    [ "Title", "Author", "ISBN", "Published Year", "Description", "Added By", "Created At" ]
  end

  def self.csv_row(book)
    [
      book.title,
      book.author.name,
      book.isbn,
      book.published_year,
      book.description,
      book.user.name,
      book.created_at.strftime("%Y-%m-%d")
    ]
  end

  def self.json_record(book)
    {
      id: book.id,
      title: book.title,
      author: {
        id: book.author.id,
        name: book.author.name
      },
      isbn: book.isbn,
      published_year: book.published_year,
      description: book.description,
      added_by: {
        id: book.user.id,
        name: book.user.name,
        email: book.user.email
      },
      created_at: book.created_at.iso8601,
      updated_at: book.updated_at.iso8601
    }
  end

  def self.to_pdf(_books)
    raise NotImplementedError, "PDF export requires additional setup"
  end
end
