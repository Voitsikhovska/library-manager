require 'rails_helper'

RSpec.describe AuthorExportService do
  let!(:author1) { create(:author, name: 'Author One', birth_year: 1950, bio: 'First author') }
  let!(:author2) { create(:author, name: 'Author Two', birth_year: 1975, bio: 'Second author') }
  let!(:book1) { create(:book, author: author1) }
  let!(:book2) { create(:book, author: author1) }
  let!(:book3) { create(:book, author: author2) }
  let(:authors) { [ author1, author2 ] }

  describe '.to_csv' do
    it 'exports authors to CSV format' do
      csv_data = AuthorExportService.to_csv(authors)

      expect(csv_data).to include('Name')
      expect(csv_data).to include('Birth Year')
      expect(csv_data).to include('Bio')
      expect(csv_data).to include('Total Books')
      expect(csv_data).to include('Author One')
      expect(csv_data).to include('Author Two')
    end

    it 'includes all required columns' do
      csv_data = AuthorExportService.to_csv(authors)
      rows = CSV.parse(csv_data)
      headers = rows.first

      expect(headers).to eq([ 'Name', 'Birth Year', 'Bio', 'Total Books', 'Created At' ])
    end

    it 'includes author data in rows' do
      csv_data = AuthorExportService.to_csv(authors)
      rows = CSV.parse(csv_data)

      expect(rows[1][0]).to eq('Author One')
      expect(rows[1][1]).to eq('1950')
      expect(rows[1][2]).to eq('First author')
      expect(rows[1][3]).to eq('2') # book count
    end

    it 'counts books correctly' do
      csv_data = AuthorExportService.to_csv(authors)
      rows = CSV.parse(csv_data)

      expect(rows[1][3]).to eq('2') # author1 has 2 books
      expect(rows[2][3]).to eq('1') # author2 has 1 book
    end
  end

  describe '.to_json' do
    it 'exports authors to JSON format' do
      json_data = AuthorExportService.to_json(authors)
      parsed = JSON.parse(json_data)

      expect(parsed).to be_an(Array)
      expect(parsed.length).to eq(2)
    end

    it 'includes author attributes' do
      json_data = AuthorExportService.to_json(authors)
      parsed = JSON.parse(json_data)
      first_author = parsed.first

      expect(first_author['name']).to eq('Author One')
      expect(first_author['birth_year']).to eq(1950)
      expect(first_author['bio']).to eq('First author')
    end

    it 'includes books count' do
      json_data = AuthorExportService.to_json(authors)
      parsed = JSON.parse(json_data)

      expect(parsed.first['books_count']).to eq(2)
      expect(parsed.second['books_count']).to eq(1)
    end

    it 'includes books data' do
      json_data = AuthorExportService.to_json(authors)
      parsed = JSON.parse(json_data)
      first_author = parsed.first

      expect(first_author['books']).to be_an(Array)
      expect(first_author['books'].length).to eq(2)
      expect(first_author['books'].first).to have_key('id')
      expect(first_author['books'].first).to have_key('title')
      expect(first_author['books'].first).to have_key('isbn')
    end
  end
end
