describe JobsController do
  describe "GET #index" do
    it "returns OK" do
      get :index
      expect(response).to be_ok
    end
  end
end
