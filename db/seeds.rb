# Clear existing data
puts "🗑️  Cleaning database..."
Book.destroy_all
Author.destroy_all
User.destroy_all

puts "👥 Creating users..."
# Create sample users
users = []
users << User.create!(
  name: "John Librarian",
  email: "john@library.com",
  password: "password123",
  password_confirmation: "password123"
)

users << User.create!(
  name: "Sarah Reader",
  email: "sarah@library.com",
  password: "password123",
  password_confirmation: "password123"
)

users << User.create!(
  name: "Mike Bookworm",
  email: "mike@library.com",
  password: "password123",
  password_confirmation: "password123"
)

puts "Created #{User.count} users"

puts "Creating authors..."
# Create famous authors
authors = []

famous_authors = [
  { name: "J.K. Rowling", birth_year: 1965, bio: "British author, best known for the Harry Potter fantasy series." },
  { name: "Stephen King", birth_year: 1947, bio: "American author of horror, supernatural fiction, suspense, crime, science-fiction, and fantasy novels." },
  { name: "Agatha Christie", birth_year: 1890, bio: "English writer known for her 66 detective novels and 14 short story collections." },
  { name: "George Orwell", birth_year: 1903, bio: "English novelist, essayist, journalist, and critic best known for 1984 and Animal Farm." },
  { name: "Jane Austen", birth_year: 1775, bio: "English novelist known primarily for her six major novels interpreting the British landed gentry." },
  { name: "Mark Twain", birth_year: 1835, bio: "American writer, humorist, entrepreneur, publisher, and lecturer." },
  { name: "Ernest Hemingway", birth_year: 1899, bio: "American novelist, short-story writer, and journalist." },
  { name: "F. Scott Fitzgerald", birth_year: 1896, bio: "American novelist, essayist, and short story writer." },
  { name: "Charles Dickens", birth_year: 1812, bio: "English writer and social critic who created some of the world's best-known fictional characters." },
  { name: "Leo Tolstoy", birth_year: 1828, bio: "Russian writer who is regarded as one of the greatest authors of all time." },
  { name: "Virginia Woolf", birth_year: 1882, bio: "English writer, considered one of the most important modernist 20th-century authors." },
  { name: "Gabriel García Márquez", birth_year: 1927, bio: "Colombian novelist, short-story writer, screenwriter, and journalist, known for magical realism." },
  { name: "Toni Morrison", birth_year: 1931, bio: "American novelist known for her examination of black identity and the black female experience." },
  { name: "Haruki Murakami", birth_year: 1949, bio: "Japanese writer whose work blends realism and fantasy." },
  { name: "Margaret Atwood", birth_year: 1939, bio: "Canadian poet, novelist, literary critic, essayist, and environmental activist." },
  { name: "Neil Gaiman", birth_year: 1960, bio: "English author of short fiction, novels, comic books, graphic novels, and films." },
  { name: "Isaac Asimov", birth_year: 1920, bio: "American writer and professor of biochemistry, known for science fiction works." },
  { name: "J.R.R. Tolkien", birth_year: 1892, bio: "English writer, poet, and philologist, best known as the author of The Hobbit and The Lord of the Rings." },
  { name: "Arthur Conan Doyle", birth_year: 1859, bio: "British writer best known for his detective fiction featuring Sherlock Holmes." },
  { name: "Oscar Wilde", birth_year: 1854, bio: "Irish poet and playwright known for his wit and flamboyant style." },
  { name: "Maya Angelou", birth_year: 1928, bio: "American memoirist, poet, and civil rights activist." },
  { name: "Kurt Vonnegut", birth_year: 1922, bio: "American writer known for his satirical and darkly humorous novels." },
  { name: "Fyodor Dostoevsky", birth_year: 1821, bio: "Russian novelist, journalist, and philosopher." },
  { name: "Emily Brontë", birth_year: 1818, bio: "English novelist and poet, best known for her only novel, Wuthering Heights." },
  { name: "Homer", birth_year: nil, bio: "Ancient Greek author of the Iliad and the Odyssey. Exact birth year unknown, lived around 800 BC." }
]

famous_authors.each do |author_data|
  authors << Author.create!(author_data.merge(user: users.sample))
end

# Create additional random authors
15.times do
  authors << Author.create!(
    name: Faker::Book.unique.author,
    birth_year: rand(1920..2000),
    bio: Faker::Lorem.paragraph(sentence_count: 3),
    user: users.sample
  )
end

puts "✅ Created #{Author.count} authors"

puts "📚 Creating books..."
# Create famous books
famous_books = [
  { title: "Harry Potter and the Philosopher's Stone", author: "J.K. Rowling", year: 1997, isbn: "ISBN-978-0439708180" },
  { title: "Harry Potter and the Chamber of Secrets", author: "J.K. Rowling", year: 1998, isbn: "ISBN-978-0439064873" },
  { title: "Harry Potter and the Prisoner of Azkaban", author: "J.K. Rowling", year: 1999, isbn: "ISBN-978-0439136365" },
  { title: "The Shining", author: "Stephen King", year: 1977, isbn: "ISBN-978-0385121675" },
  { title: "It", author: "Stephen King", year: 1986, isbn: "ISBN-978-0670813025" },
  { title: "The Stand", author: "Stephen King", year: 1978, isbn: "ISBN-978-0385121682" },
  { title: "Murder on the Orient Express", author: "Agatha Christie", year: 1934, isbn: "ISBN-978-0062693662" },
  { title: "And Then There Were None", author: "Agatha Christie", year: 1939, isbn: "ISBN-978-0062073488" },
  { title: "1984", author: "George Orwell", year: 1949, isbn: "ISBN-978-0451524935" },
  { title: "Animal Farm", author: "George Orwell", year: 1945, isbn: "ISBN-978-0451526342" },
  { title: "Pride and Prejudice", author: "Jane Austen", year: 1813, isbn: "ISBN-978-0141439518" },
  { title: "Sense and Sensibility", author: "Jane Austen", year: 1811, isbn: "ISBN-978-0141439662" },
  { title: "The Adventures of Tom Sawyer", author: "Mark Twain", year: 1876, isbn: "ISBN-978-0486400778" },
  { title: "The Adventures of Huckleberry Finn", author: "Mark Twain", year: 1884, isbn: "ISBN-978-0486280615" },
  { title: "The Old Man and the Sea", author: "Ernest Hemingway", year: 1952, isbn: "ISBN-978-0684801223" },
  { title: "The Great Gatsby", author: "F. Scott Fitzgerald", year: 1925, isbn: "ISBN-978-0743273565" },
  { title: "A Tale of Two Cities", author: "Charles Dickens", year: 1859, isbn: "ISBN-978-0141439600" },
  { title: "Great Expectations", author: "Charles Dickens", year: 1861, isbn: "ISBN-978-0141439563" },
  { title: "War and Peace", author: "Leo Tolstoy", year: 1869, isbn: "ISBN-978-0140447934" },
  { title: "Anna Karenina", author: "Leo Tolstoy", year: 1877, isbn: "ISBN-978-0143035008" },
  { title: "Mrs Dalloway", author: "Virginia Woolf", year: 1925, isbn: "ISBN-978-0156628709" },
  { title: "One Hundred Years of Solitude", author: "Gabriel García Márquez", year: 1967, isbn: "ISBN-978-0060883287" },
  { title: "Beloved", author: "Toni Morrison", year: 1987, isbn: "ISBN-978-1400033416" },
  { title: "Norwegian Wood", author: "Haruki Murakami", year: 1987, isbn: "ISBN-978-0375704024" },
  { title: "The Handmaid's Tale", author: "Margaret Atwood", year: 1985, isbn: "ISBN-978-0385490818" },
  { title: "American Gods", author: "Neil Gaiman", year: 2001, isbn: "ISBN-978-0380789030" },
  { title: "Foundation", author: "Isaac Asimov", year: 1951, isbn: "ISBN-978-0553293357" },
  { title: "The Hobbit", author: "J.R.R. Tolkien", year: 1937, isbn: "ISBN-978-0618260300" },
  { title: "The Lord of the Rings", author: "J.R.R. Tolkien", year: 1954, isbn: "ISBN-978-0618640157" },
  { title: "The Hound of the Baskervilles", author: "Arthur Conan Doyle", year: 1902, isbn: "ISBN-978-0486282145" },
  { title: "The Picture of Dorian Gray", author: "Oscar Wilde", year: 1890, isbn: "ISBN-978-0141439570" },
  { title: "I Know Why the Caged Bird Sings", author: "Maya Angelou", year: 1969, isbn: "ISBN-978-0345514400" },
  { title: "Slaughterhouse-Five", author: "Kurt Vonnegut", year: 1969, isbn: "ISBN-978-0385333849" },
  { title: "Crime and Punishment", author: "Fyodor Dostoevsky", year: 1866, isbn: "ISBN-978-0486415871" },
  { title: "Wuthering Heights", author: "Emily Brontë", year: 1847, isbn: "ISBN-978-0141439556" },
  { title: "The Odyssey", author: "Homer", year: nil, isbn: "ISBN-978-0140268867" }
]

famous_books.each do |book_data|
  author = Author.find_by(name: book_data[:author])
  next unless author

  Book.create!(
    title: book_data[:title],
    author: author,
    isbn: book_data[:isbn],
    published_year: book_data[:year],
    description: Faker::Lorem.paragraph(sentence_count: 5),
    user: users.sample
  )
end

# Create additional random books
60.times do
  Book.create!(
    title: Faker::Book.unique.title,
    author: authors.sample,
    isbn: "ISBN-#{Faker::Number.unique.number(digits: 13)}",
    published_year: rand(1950..2025),
    description: Faker::Lorem.paragraph(sentence_count: rand(3..7)),
    user: users.sample
  )
end

puts "✅ Created #{Book.count} books"

puts "\n🎉 Seed data created successfully!"
puts "=" * 50
puts "📊 Summary:"
puts "  Users: #{User.count}"
puts "  Authors: #{Author.count}"
puts "  Books: #{Book.count}"
puts "=" * 50
puts "\n📝 Sample login credentials:"
puts "  👤 john@library.com / password123"
puts "  👤 sarah@library.com / password123"
puts "  👤 mike@library.com / password123"
puts "=" * 50
