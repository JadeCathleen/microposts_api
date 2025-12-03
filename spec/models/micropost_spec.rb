require 'rails_helper'

RSpec.describe Micropost, type: :model do
  describe "Validations" do
    context "title" do
      it 'is invalid without a title' do
        post = Micropost.new(body: "Hello it's me")
        expect(post).to_not be_valid
        expect(post.errors[:title]).to include("can't be blank")
      end

      it "is not valid if title if too long" do
        post = Micropost.new(title: "a" * 52, body: "hello it's me")

        expect(post).not_to be_valid
        expect(post.errors[:title]).to include("is too long (maximum is 50 characters)")
      end
    end

    context "body" do
      it 'is invalid without a body' do
        post = Micropost.new(title: "Hello it's me")
        expect(post).to_not be_valid
        expect(post.errors[:body]).to include("can't be blank")
      end

      it "is not valid if body if too long" do
        post = Micropost.new(body: "a" * 200, title: "hello it's me")

        expect(post).not_to be_valid
        expect(post.errors[:body]).to include("is too long (maximum is 140 characters)")
      end
    end
  end
end
