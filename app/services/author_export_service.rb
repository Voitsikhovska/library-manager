require "csv"

class AuthorExportService
  def self.to_csv(authors)
    CSV.generate(headers: true) do |csv|
      csv << [ "Name", "Birth Year", "Bio", "Total Books", "Created At" ]

      authors.each do |author|
        csv << [
          author.name,
          author.birth_year,
          author.bio,
          author.books.count,
          author.created_at.strftime("%Y-%m-%d")
        ]
      end
    end
  end

  def self.to_json(authors)
    authors.map do |author|
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
    end.to_json
  end
end
