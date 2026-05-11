require 'rails_helper'

RSpec.describe Author, type: :model do
  describe 'associations' do
    it { should have_many(:books).dependent(:destroy) }
  end

  describe 'validations' do
    subject { build(:author) }

    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name).case_insensitive }

    it 'validates numericality of birth_year' do
      author = build(:author, birth_year: 'invalid')
      expect(author).not_to be_valid
    end

    it 'allows nil birth_year' do
      author = build(:author, birth_year: nil)
      expect(author).to be_valid
    end
  end

  describe 'scopes' do
    let!(:author1) { create(:author, name: 'John Doe', birth_year: 1950) }
    let!(:author2) { create(:author, name: 'Jane Smith', birth_year: 1975) }
    let!(:author3) { create(:author, name: 'Bob Johnson', birth_year: 1960) }

    describe '.by_name' do
      it 'filters authors by name (case insensitive)' do
        results = Author.by_name('john')
        expect(results).to include(author1, author3)
        expect(results).not_to include(author2)
      end
    end

    describe '.by_birth_year' do
      it 'filters authors by birth year' do
        results = Author.by_birth_year(1950)
        expect(results).to eq([ author1 ])
      end
    end

    describe '.by_birth_year_range' do
      it 'filters authors by birth year range' do
        results = Author.by_birth_year_range(1950, 1960)
        expect(results).to include(author1, author3)
        expect(results).not_to include(author2)
      end
    end

    describe '.alphabetical' do
      it 'orders authors alphabetically by name' do
        results = Author.alphabetical
        expect(results).to eq([ author3, author2, author1 ])
      end
    end
  end

  describe 'cascading delete' do
    it 'destroys associated books when author is destroyed' do
      author = create(:author, :with_books)
      expect { author.destroy }.to change { Book.count }.by(-5)
    end
  end

  describe 'optional fields' do
    it 'is valid without bio' do
      author = build(:author, :without_bio)
      expect(author).to be_valid
    end

    it 'is valid without birth_year' do
      author = build(:author, :without_birth_year)
      expect(author).to be_valid
    end
  end
end
