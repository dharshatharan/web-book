require "rails_helper"

RSpec.describe(Tag, type: :model) do
  let(:website) { build(:website) }
  let(:tag) { build(:tag) }

  describe "Tag Attribute Validations" do
    let(:result) { tag.valid? }

    it "valid tag" do
      expect(result).to(be(true))
    end

    context "when tag has no name" do
      before { tag.name = nil }

      it "returns false" do
        expect(result).to(be(false))
      end
    end

    context "when two tags have the same name" do
      let(:tag_copy) { create(:tag, name: tag.name) }

      before do
        tag.name = tag_copy.name
      end

      it "returns false" do
        expect(result).to(be(false))
      end
    end
  end

  describe Queries::Tags do
    before do
      prepare_query_variables({})
      prepare_context({})

      create_list(:tag, 3)
    end

    context "when there are 3 tags in the database" do
      it "returns a result with a length of 3" do
        prepare_query('{
                tags{
                    id
                }
            }')

        tags = graphql!["data"]["tags"]
        expect(tags.length).to(eq(3))
      end
    end
  end

  # describe Queries::Websites do
  #   before do
  #     prepare_query_variables({})
  #     prepare_context({})

  #     # website.id = 1
  #     # tag.id = 1
  #     @website_tag = create(:website_tag, website: website, tag: tag)
  #   end

  #   context "when there are 3 tags in the database" do
  #     it "returns a result with a length of 3" do
  #       prepare_query('{
  #               tags{
  #                   websites
  #               }
  #           }')

  #       puts(graphql!["data"])
  #       tags = graphql!["data"]["tags"]
  #       expect(tags.length).to(eq(1))
  #     end
  #   end
  # end
end
