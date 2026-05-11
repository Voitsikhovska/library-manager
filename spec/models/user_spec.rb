require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_many(:books).dependent(:destroy) }
  end

  describe 'validations' do
    subject { build(:user) }

    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should allow_value('user@example.com').for(:email) }
    it { should_not allow_value('invalid_email').for(:email) }
    it { should have_secure_password }
    it { should validate_length_of(:password).is_at_least(6) }
  end

  describe 'password encryption' do
    it 'encrypts the password' do
      user = create(:user, password: 'securepassword', password_confirmation: 'securepassword')
      expect(user.password_digest).not_to eq('securepassword')
    end

    it 'authenticates with correct password' do
      user = create(:user, password: 'securepassword', password_confirmation: 'securepassword')
      expect(user.authenticate('securepassword')).to eq(user)
    end

    it 'does not authenticate with incorrect password' do
      user = create(:user, password: 'securepassword', password_confirmation: 'securepassword')
      expect(user.authenticate('wrongpassword')).to be_falsey
    end
  end

  describe 'cascading delete' do
    it 'destroys associated books when user is destroyed' do
      user = create(:user, :with_books)
      expect { user.destroy }.to change { Book.count }.by(-3)
    end
  end

  describe 'email format validation' do
    let(:user) { build(:user) }

    it 'accepts valid email addresses' do
      valid_emails = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
      valid_emails.each do |valid_email|
        user.email = valid_email
        expect(user).to be_valid, "#{valid_email.inspect} should be valid"
      end
    end

    it 'rejects invalid email addresses' do
      invalid_emails = %w[user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com]
      invalid_emails.each do |invalid_email|
        user.email = invalid_email
        expect(user).not_to be_valid, "#{invalid_email.inspect} should be invalid"
      end
    end
  end

  describe 'password length validation' do
    it 'rejects passwords that are too short' do
      user = build(:user, password: 'short', password_confirmation: 'short')
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include(/too short/)
    end
  end
end

