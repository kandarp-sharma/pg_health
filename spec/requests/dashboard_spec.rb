require 'rails_helper'

RSpec.describe "Dashboard Controller", type: :request do
  describe "GET /" do
    it "renders the dashboard successfully" do
      get pg_health.root_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("PgHealth Dashboard")
    end
  end
end