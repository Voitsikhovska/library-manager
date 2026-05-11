require 'rails_helper'

RSpec.describe BookSearchService do
  let(:user) { create(:user) }
  let(:author1) { create(:author, name: 'J.K. Rowling') }
  let(:author2) { create(:author, name: 'George Orwell') }

  let!(:book1) { create(:book, title: 'Harry Potter', description: 'Magic book', isbn: 'ISBN-1', author: author1, user: user, published_year: 1997) }
  let!(:book2) { create(:book, title: '1984', description: 'Dystopian novel', isbn: 'ISBN-2', author: author2, user: user, published_year: 1949) }
  let!(:book3) { create(:book, title: 'Animal Farm', description: 'Political satire', isbn: 'ISBN-3', author: author2, user: user, published_year: 1945) }

  describe '#call' do
    context 'without any filters' do
      it 'returns all books' do
        service = BookSearchService.new({})
        results = service.call
        expect(results).to match_array([ book1, book2, book3 ])
      end
    end

    context 'with search term' do
      it 'searches in title' do
        service = BookSearchService.new(search: 'harry')
        results = service.call
        expect(results).to eq([ book1 ])
      end

      it 'searches in description' do
        service = BookSearchService.new(search: 'dystopian')
        results = service.call
        expect(results).to eq([ book2 ])
      end

      it 'searches in ISBN' do
        service = BookSearchService.new(search: 'ISBN-2')
        results = service.call
        expect(results).to eq([ book2 ])
      end

      it 'is case insensitive' do
        service = BookSearchService.new(search: 'HARRY')
        results = service.call
        expect(results).to eq([ book1 ])
      end
    end

    context 'with author filter' do
      it 'filters by author_id' do
        service = BookSearchService.new(author_id: author2.id)
        results = service.call
        expect(results).to match_array([ book2, book3 ])
      end
    end

    context 'with year range filter' do
      it 'filters by year_from' do
        service = BookSearchService.new(year_from: 1949)
        results = service.call
        expect(results).to match_array([ book1, book2 ])
      end

      it 'filters by year_to' do
        service = BookSearchService.new(year_to: 1949)
        results = service.call
        expect(results).to match_array([ book2, book3 ])
      end

      it 'filters by year range' do
        service = BookSearchService.new(year_from: 1945, year_to: 1949)
        results = service.call
        expect(results).to match_array([ book2, book3 ])
      end
    end

    context 'with combined filters' do
      it 'applies multiple filters' do
        service = BookSearchService.new(
          search: 'farm',
          author_id: author2.id,
          year_from: 1940,
          year_to: 1950
        )
        results = service.call
        expect(results).to eq([ book3 ])
      end
    end
  end
end
