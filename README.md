# 📚 Library Manager

A Ruby on Rails web application for managing a library of books and authors.

---

## 🛠 Requirements

| Tool | Version |
|------|---------|
| Ruby | 3.2.6 |
| Rails | 8.0.5 |
| Node.js | 22.7.0+ |
| PostgreSQL | 14+ |
| Bundler | latest |

---

## 🚀 Getting Started

### 1. Clone the repository

```bash
git clone <repository-url>
cd library-manager
```

### 2. Install Ruby 3.2.6

With `asdf`:
```bash
asdf install ruby 3.2.6
asdf local ruby 3.2.6
```

With `rbenv`:
```bash
rbenv install 3.2.6
rbenv local 3.2.6
```

Verify: `ruby -v`

### 3. Install Ruby dependencies

```bash
bundle install
```

### 4. Install JavaScript dependencies

```bash
npm install
```

### 5. Start PostgreSQL

macOS:
```bash
brew services start postgresql@14
```

Linux:
```bash
sudo systemctl start postgresql
```

Verify: `pg_isready`

### 6. Setup the database

```bash
bin/rails db:create
bin/rails db:migrate
bin/rails db:seed
```

### 7. Build Tailwind CSS

```bash
bin/rails tailwindcss:build
```

### 8. Start the server

```bash
bundle exec rails s
```

Visit **http://localhost:3000**

---

## 🌱 Sample Login Accounts

After running `db:seed`:

| Email | Password |
|-------|----------|
| john@library.com | password123 |
| sarah@library.com | password123 |
| mike@library.com | password123 |

---

## 🧪 Running Tests

```bash
# Setup test database
RAILS_ENV=test bin/rails db:create db:schema:load

# Run all tests
bundle exec rspec
```

---

## 🔧 Troubleshooting

| Problem | Solution |
|---------|----------|
| PostgreSQL not running | `brew services start postgresql@14` |
| Database missing | `bin/rails db:create` |
| Pending migrations | `bin/rails db:migrate` |
| Styles not updating | `bin/rails tailwindcss:build` |
| Tailwind plugins missing | `npm install` |
| Reset everything | `bin/rails db:drop db:create db:migrate db:seed` |

---

## 📖 How to Use the Application

### 🔐 Authentication

- Visit **http://localhost:3000** and click **"Log In"** or **"Sign Up"**
- After logging in you will see your personal dashboard with stats

### 📚 Managing Books

| Action | How |
|--------|-----|
| View all books | Click **"Books"** in the navigation bar |
| Add a book | Click **"Add New Book"** (must be logged in) |
| Edit a book | Click **"Edit"** on a book card (only your own books) |
| Delete a book | Click **"Delete"** on a book card (only your own books) |
| View book details | Click the book title |

### ✍️ Managing Authors

| Action | How |
|--------|-----|
| View all authors | Click **"Authors"** in the navigation bar |
| Add an author | Click **"Add New Author"** (must be logged in) |
| Edit an author | Click **"Edit"** on an author card (only authors you created) |
| Delete an author | Click **"Delete"** — this also deletes all their books! |
| View author details | Click the author name |

### 🔍 Search & Filter Books

On the **Books** page you can filter by:
- **Search** — search by title, description, or ISBN
- **Author** — select an author from the dropdown
- **Year range** — filter by publication year (From / To)
- **Sort** — sort by Most Recent or Title A-Z

Click **"Filter"** to apply, **"Clear Filters"** to reset.

### 📤 Export Data

On the **Books** or **Authors** page, click:
- **"CSV"** — downloads a `.csv` file (opens in Excel/Numbers)
- **"JSON"** — downloads a `.json` file (for developers/APIs)

### 👤 User Profile

Click your name in the top navigation bar to see:
- Your personal stats (books added, authors created)
- Your recent books and authors
- Quick action buttons

### 🔒 Who Can Do What?

| Action | Permission |
|--------|-----------|
| View books & authors | Everyone (no login needed) |
| Export CSV / JSON | Everyone (no login needed) |
| Add a book | Any logged-in user |
| Edit / Delete a book | Only the user who added it |
| Add an author | Any logged-in user |
| Edit / Delete an author | Only the user who created it |


