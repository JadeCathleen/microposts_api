require 'rails_helper'

RSpec.describe "/microposts", type: :request do
  let!(:micropost_1)  { Micropost.create!(title: "Hello", body: "I am a post") }
  let!(:micropost_2)  { Micropost.create!(title: "Hi!", body: " I am also a post") }
  let(:valid_params) { { title: "Hola!", body: "I am a brand new post!" } }
  let(:invalid_params) { { body: "I am missing a title" } }

  describe "GET /index" do
    it "renders a successful response and correct JSON response" do
      get microposts_url, as: :json
      expect(response).to be_successful
      json_response = JSON.parse(response.body)
      expect(json_response["microposts"].count).to eq(2)
      expect(json_response["microposts"]).to match_array([
        { "id" => micropost_1.id, "title" => micropost_1.title, "body" => micropost_1.body },
        { "id" => micropost_2.id, "title" => micropost_2.title, "body" => micropost_2.body }
      ])
    end
  end

  describe "GET /show" do
    it "renders a successful response and correct JSON response" do
      get micropost_url(micropost_1), as: :json
      expect(response).to be_successful
      expect(JSON.parse(response.body)).to eq({
        "id" => micropost_1.id,
        "title" => micropost_1.title,
        "body" => micropost_1.body
      })
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Micropost and renders a JSON response with the new micropost" do
        expect {
          post microposts_url,
               params: { micropost: valid_params }, as: :json
        }.to change(Micropost, :count).by(1)
        expect(response).to have_http_status(:created)
        expect(Micropost.last.title).to eq("Hola!")
        json_response = JSON.parse(response.body)
        expect(json_response["micropost"]["title"]).to eq(valid_params[:title])
        expect(json_response["micropost"]["body"]).to eq(valid_params[:body])
        expect(json_response["flash"]["notice"]).to eq("Micropost created successfully!")
      end
    end

    context "with invalid parameters" do
      it "does not create a new Micropost and renders a JSON response with errors for the new micropost" do
        expect {
          post microposts_url,
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
      it "updates the requested micropost and renders a JSON response with the micropost" do
        patch micropost_url(micropost_1),
              params: { micropost: valid_params }, as: :json
        expect(micropost_1.reload.title).to eq("Hola!")
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response["micropost"]["title"]).to eq("Hola!")
        expect(json_response["micropost"]["body"]).to eq("I am a brand new post!")
        expect(json_response["flash"]["notice"]).to eq("Micropost updated successfully!")
      end
    end

    context "with invalid parameters" do
      it "renders a JSON response with errors for the micropost" do
        patch micropost_url(micropost_1),
              params: { micropost: { title: "Hello" * 20 } }, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including("application/json"))
        expect(JSON.parse(response.body)["flash"]["alert"]).to eq("Failed to update micropost (Title is too long (maximum is 50 characters))")
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested micropost" do
      expect {
        delete micropost_url(micropost_2), as: :json
      }.to change(Micropost, :count).by(-1)
    end
  end
end
