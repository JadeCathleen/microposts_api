require 'rails_helper'

RSpec.describe "api/v1/microposts", type: :request do
  let!(:user) { FactoryBot.create(:user) }
  let!(:other_user) { FactoryBot.create(:user) }
  let!(:user_headers) { Devise::JWT::TestHelpers.auth_headers({}, user) }
  let!(:micropost_1)  { FactoryBot.create(:micropost, user:) }
  let!(:micropost_2)  { FactoryBot.create(:micropost, title: "Hi!", body: " I am also a post", user: other_user) }
  let(:valid_params) { { title: "Hola!", body: "I am a brand new post!", user_id: user.id } }
  let(:invalid_params) { { body: "I am missing a title", user_id: user.id } }

  describe "GET /index" do
    context "with authentication" do
      it "renders a successful response and correct JSON response" do
        get api_v1_microposts_url, headers: user_headers, as: :json
        expect(response).to be_successful
        json_response = JSON.parse(response.body)
        expect(json_response["microposts"].count).to eq(2)
        expect(json_response["microposts"]).to match_array([
          {
            "id" => micropost_1.id,
            "title" => micropost_1.title,
            "body" => micropost_1.body,
            "created_at" => micropost_1.created_at.to_date.strftime("%B %d, %Y"),
            "updated_at" => micropost_1.updated_at.to_date.strftime("%B %d, %Y"),
            "user"  => {
              "id" => user.id,
              "username" => user.username
            }
          },
          {
            "id" => micropost_2.id,
            "title" => micropost_2.title,
            "body" => micropost_2.body,
            "created_at" => micropost_2.created_at.to_date.strftime("%B %d, %Y"),
            "updated_at" => micropost_2.updated_at.to_date.strftime("%B %d, %Y"),
            "user"  => {
              "id" => other_user.id,
              "username" => other_user.username
            }
          }
        ])
      end
    end

    context "without authentication" do
      it "renders a 401 unauthorized response" do
        get api_v1_microposts_url, as: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "GET /show" do
    context "with authentication" do
      it "renders a successful response and correct JSON response" do
        get api_v1_micropost_url(micropost_1), headers: user_headers, as: :json
        expect(response).to be_successful
        expect(JSON.parse(response.body)).to eq({
          "id" => micropost_1.id,
          "title" => micropost_1.title,
          "body" => micropost_1.body,
          "created_at" => micropost_1.created_at.to_date.strftime("%B %d, %Y"),
          "updated_at" => micropost_1.updated_at.to_date.strftime("%B %d, %Y"),
          "user"  => {
            "id" => user.id,
            "username" => user.username
          }
        })
      end
    end

    context "without authentication" do
      it "renders a 401 unauthorized response" do
        get api_v1_micropost_url(micropost_1), as: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "works with authentication" do
        expect {
          post api_v1_microposts_url,
                headers: user_headers,
                params: { micropost: valid_params }, as: :json
        }.to change(Micropost, :count).by(1)
        expect(response).to have_http_status(:created)
        expect(Micropost.last.title).to eq("Hola!")
        json_response = JSON.parse(response.body)
        expect(json_response["micropost"]["title"]).to eq(valid_params[:title])
        expect(json_response["micropost"]["body"]).to eq(valid_params[:body])
        expect(json_response["user"]["id"]).to eq(user.id)
        expect(json_response["flash"]["notice"]).to eq("Micropost created successfully!")
      end

      it "fails without authentication" do
        expect {
          post api_v1_microposts_url,
                params: { micropost: valid_params }, as: :json
        }.to change(Micropost, :count).by(0)
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "with invalid parameters" do
      it "fails with authentication" do
        expect {
          post api_v1_microposts_url,
                headers: user_headers,
                params: { micropost: invalid_params }, as: :json
        }.to change(Micropost, :count).by(0)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including("application/json"))
        expect(JSON.parse(response.body)["flash"]["alert"]).to eq("Failed to create micropost (Title can't be blank)")
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      it "works with correct authentication" do
        patch api_v1_micropost_url(micropost_1),
              headers: user_headers,
              params: { micropost: valid_params }, as: :json
        expect(micropost_1.reload.title).to eq("Hola!")
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response["micropost"]["title"]).to eq("Hola!")
        expect(json_response["micropost"]["body"]).to eq("I am a brand new post!")
        expect(json_response["flash"]["notice"]).to eq("Micropost updated successfully!")
      end

      it "fails with incorrect authentication" do
        patch api_v1_micropost_url(micropost_2),
              headers: user_headers,
              params: { micropost: valid_params }, as: :json
        expect(response).to have_http_status(:not_found)
      end
    end

    context "with invalid parameters" do
      it "fails with correct authentication" do
        patch api_v1_micropost_url(micropost_1),
              headers: user_headers,
              params: { micropost: { title: "Hello" * 20 } }, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including("application/json"))
        expect(JSON.parse(response.body)["flash"]["alert"]).to eq("Failed to update micropost (Title is too long (maximum is 50 characters))")
      end
    end
  end

  describe "DELETE /destroy" do
    it "works with correct authentication" do
      expect {
        delete api_v1_micropost_url(micropost_1), headers: user_headers, as: :json
      }.to change(Micropost, :count).by(-1)
    end

    it "fails with incorrect authentication" do
      expect {
        delete api_v1_micropost_url(micropost_2), headers: user_headers, as: :json
      }.to change(Micropost, :count).by(0)
      expect(response).to have_http_status(:not_found)
    end
  end
end
