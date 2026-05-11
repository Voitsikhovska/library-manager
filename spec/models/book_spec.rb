require 'rails_helper'

RSpec.describe Book, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:author) }
  end

  describe 'validations' do
    subject { build(:book) }

    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:isbn) }
    it { should validate_uniqueness_of(:isbn).case_insensitive }
    it { should validate_presence_of(:user_id) }
    it { should validate_presence_of(:author_id) }

    it 'validates numericality of published_year' do
      book = build(:book, published_year: 'invalid')
      expect(book).not_to be_valid
    end

    it 'allows nil published_year' do
      user = create(:user)
      author = create(:author)
      book = build(:book, published_year: nil, user: user, author: author)
      expect(book).to be_valid
    end
  end

  describe 'scopes' do
    let(:user) { create(:user) }
    let(:author1) { create(:author, name: 'Author One') }
    let(:author2) { create(:author, name: 'Author Two') }

    let!(:book1) { create(:book, title: 'Ruby Programming', author: author1, user: user, published_year: 2020) }
    let!(:book2) { create(:book, title: 'Rails Guide', author: author2, user: user, published_year: 2019) }
    let!(:book3) { create(:book, title: 'Advanced Ruby', author: author1, user: user, published_year: 2021) }

    describe '.by_title' do
      it 'filters books by title (case insensitive)' do
        results = Book.by_title('ruby')
        expect(results).to include(book1, book3)
        expect(results).not_to include(book2)
      end
    end

    describe '.by_author' do
      it 'filters books by author_id' do
        results = Book.by_author(author1.id)
        expect(results).to include(book1, book3)
        expect(results).not_to include(book2)
      end
    end

    describe '.by_year' do
      it 'filters books by published year' do
        results = Book.by_year(2020)
        expect(results).to eq([ book1 ])
      end
    end

    describe '.by_year_range' do
      it 'filters books by year range' do
        results = Book.by_year_range(2019, 2020)
        expect(results).to include(book1, book2)
        expect(results).not_to include(book3)
      end
    end

    describe '.recent' do
      it 'orders books by created_at descending' do
        results = Book.recent
        expect(results.first).to eq(book3)
      end
    end

    describe '.alphabetical' do
      it 'orders books alphabetically by title' do
        results = Book.alphabetical
        expect(results.pluck(:title)).to eq([ 'Advanced Ruby', 'Rails Guide', 'Ruby Programming' ])
      end
    end
  end

  describe 'ISBN uniqueness' do
    it 'does not allow duplicate ISBNs' do
      book1 = create(:book, isbn: 'ISBN-123-456')
      book2 = build(:book, isbn: 'ISBN-123-456')
      expect(book2).not_to be_valid
      expect(book2.errors[:isbn]).to include(/has already been taken/)
    end
  end
end
