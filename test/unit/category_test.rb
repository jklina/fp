require 'test_helper'

class CategoryTest < Test::Unit::TestCase
  context "The Category class" do
    should     allow_mass_assignment_of(:title)
    should     allow_mass_assignment_of(:description)
    should_not allow_mass_assignment_of(:id)
    should_not allow_mass_assignment_of(:created_at)
    should_not allow_mass_assignment_of(:updated_at)

    should have_many(:submissions)

    should validate_presence_of(:title)
  end

  context "A Category instance" do
    setup do
      @category = Factory(:category)
    end

    should "produce HTML when calling body_html if a description is present" do
      assert @category.description.present?
      assert_equal RedCloth.new(@category.description).to_html, @category.description_html
    end

    should "produce an empty string when calling body_html if no description is present" do
      @category.description = nil
      assert @category.description.blank?
      assert_equal "", @category.description_html
    end
  end
end
