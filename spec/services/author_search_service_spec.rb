require 'rails_helper'

RSpec.describe AuthorSearchService do
  let!(:author1) { create(:author, name: 'J.K. Rowling', bio: 'British author', birth_year: 1965) }
  let!(:author2) { create(:author, name: 'George Orwell', bio: 'English novelist', birth_year: 1903) }
  let!(:author3) { create(:author, name: 'Jane Austen', bio: 'English writer', birth_year: 1775) }

  describe '#call' do
    context 'without any filters' do
      it 'returns all authors' do
        service = AuthorSearchService.new({})
        results = service.call
        expect(results).to match_array([author1, author2, author3])
      end
    end

    context 'with search term' do
      it 'searches in name' do
        service = AuthorSearchService.new(search: 'rowling')
        results = service.call
        expect(results).to eq([author1])
      end

      it 'searches in bio' do
        service = AuthorSearchService.new(search: 'novelist')
        results = service.call
        expect(results).to eq([author2])
      end

      it 'is case insensitive' do
        service = AuthorSearchService.new(search: 'ORWELL')
        results = service.call
        expect(results).to eq([author2])
      end
    end

    context 'with birth year range filter' do
      it 'filters by birth_year_from' do
        service = AuthorSearchService.new(birth_year_from: 1900)
        results = service.call
        expect(results).to match_array([author1, author2])
      end

      it 'filters by birth_year_to' do
        service = AuthorSearchService.new(birth_year_to: 1900)
        results = service.call
        expect(results).to match_array([author3])
      end

      it 'filters by birth year range' do
        service = AuthorSearchService.new(birth_year_from: 1800, birth_year_to: 1950)
        results = service.call
        expect(results).to match_array([author2])  # Only George Orwell (1903 is between 1800-1950)
      end
    end

    context 'with combined filters' do
      it 'applies multiple filters' do
        service = AuthorSearchService.new(
          search: 'english',
          birth_year_from: 1800,
          birth_year_to: 1950
        )
        results = service.call
        expect(results).to match_array([author2])  # Only George Orwell (English + 1800-1950)
      end
    end
  end
end

