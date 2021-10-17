require "rails_helper"

RSpec.describe(Website, type: :model) do
  let(:website) { build(:website) }

  describe "Website Attribute Validations" do
    let(:result) { website.valid? }

    context "when website has no url" do
      before { website.url = nil }

      it "returns false" do
        expect(result).to(be(false))
      end
    end

    context "when website has no domain" do
      before { website.domain = nil }

      it "returns false" do
        expect(result).to(be(false))
      end
    end

    context "when website has invalid url" do
      before { website.url = "invalid" }

      it "returns false" do
        expect(result).to(be(false))
      end
    end

    context "when website has negative price" do
      before { website.domain = "invalid" }

      it "returns false" do
        expect(result).to(be(false))
      end
    end
  end
end
