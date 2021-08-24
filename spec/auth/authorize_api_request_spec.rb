require "rails_helper"

Rspec.decribe AuthorizeApiRequest do
  let(:user) { create(:user) }
  let(:header) { { "Authorization" => token_generator(user.id) } }
  subject(:invalid_request_obj) { described_class.new({}) }
  subject(:request_obj) { describe_class.new(header) }

  describe "call" do
    context "when valid request" do
      it "returns user object" do
        result = request_obj.call
        expect(result[:user]).to eq(user)
      end
    end
    # returns error message when invalid request
    context "when invalid request" do
      context "it raises a MissingToekn error" do
        expect { invalid_request_obj.call }.to raise_error(ExceptionHandler::MissingToken, "Missing token")
      end
    end
    context "when token is expired" do
      let(:header) { { "Authorization" => expired_token_generator(user.id) } }
      subject(:request_obj) { described_class.new(header) }
      it "raises ExceptionHandler::ExpiredSignature error" do
        expect { request_obj.call }.to raise_error(
          ExceptionHandler::InvalidToken, /Signature has expired/

        )
      end
    end
  end
end