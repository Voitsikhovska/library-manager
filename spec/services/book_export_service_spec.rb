require 'rails_helper'

RSpec.describe BookExportService do
  let(:user) { create(:user, name: 'John Doe') }
  let(:author) { create(:author, name: 'Jane Author') }
  let!(:book1) { create(:book, title: 'Book One', author: author, user: user, isbn: 'ISBN-1', published_year: 2020, description: 'First book') }
  let!(:book2) { create(:book, title: 'Book Two', author: author, user: user, isbn: 'ISBN-2', published_year: 2021, description: 'Second book') }
  let(:books) { [ book1, book2 ] }

  describe '.to_csv' do
    it 'exports books to CSV format' do
      csv_data = BookExportService.to_csv(books)

      expect(csv_data).to include('Title')
      expect(csv_data).to include('Author')
      expect(csv_data).to include('ISBN')
      expect(csv_data).to include('Book One')
      expect(csv_data).to include('Book Two')
      expect(csv_data).to include('Jane Author')
      expect(csv_data).to include('ISBN-1')
      expect(csv_data).to include('ISBN-2')
    end

    it 'includes all required columns' do
      csv_data = BookExportService.to_csv(books)
      rows = CSV.parse(csv_data)
      headers = rows.first

      expect(headers).to eq([ 'Title', 'Author', 'ISBN', 'Published Year', 'Description', 'Added By', 'Created At' ])
    end

    it 'includes book data in rows' do
      csv_data = BookExportService.to_csv(books)
      rows = CSV.parse(csv_data)

      expect(rows[1][0]).to eq('Book One')
      expect(rows[1][1]).to eq('Jane Author')
      expect(rows[1][2]).to eq('ISBN-1')
      expect(rows[1][3]).to eq('2020')
    end
  end

  describe '.to_json' do
    it 'exports books to JSON format' do
      json_data = BookExportService.to_json(books)
      parsed = JSON.parse(json_data)

      expect(parsed).to be_an(Array)
      expect(parsed.length).to eq(2)
    end

    it 'includes book attributes' do
      json_data = BookExportService.to_json(books)
      parsed = JSON.parse(json_data)
      first_book = parsed.first

      expect(first_book['title']).to eq('Book One')
      expect(first_book['isbn']).to eq('ISBN-1')
      expect(first_book['published_year']).to eq(2020)
      expect(first_book['description']).to eq('First book')
    end

    it 'includes nested author data' do
      json_data = BookExportService.to_json(books)
      parsed = JSON.parse(json_data)
      first_book = parsed.first

      expect(first_book['author']).to be_a(Hash)
      expect(first_book['author']['name']).to eq('Jane Author')
    end

    it 'includes nested user data' do
      json_data = BookExportService.to_json(books)
      parsed = JSON.parse(json_data)
      first_book = parsed.first

      expect(first_book['added_by']).to be_a(Hash)
      expect(first_book['added_by']['name']).to eq('John Doe')
    end
  end

  describe '.to_pdf' do
    it 'raises NotImplementedError' do
      expect {
        BookExportService.to_pdf(books)
      }.to raise_error(NotImplementedError, /PDF export requires additional setup/)
    end
  end
end
