require "csv"

class BookExportService
  def self.to_csv(books)
    CSV.generate(headers: true) do |csv|
      csv << [ "Title", "Author", "ISBN", "Published Year", "Description", "Added By", "Created At" ]

      books.each do |book|
        csv << [
          book.title,
          book.author.name,
          book.isbn,
          book.published_year,
          book.description,
          book.user.name,
          book.created_at.strftime("%Y-%m-%d")
        ]
      end
    end
  end

  def self.to_json(books)
    books.map do |book|
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
    end.to_json
  end

  def self.to_pdf(books)
    # PDF export would require additional gem like 'prawn'
    # This is a placeholder for future implementation
    raise NotImplementedError, "PDF export requires additional setup"
  end
end
