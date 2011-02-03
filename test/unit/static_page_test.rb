require 'test_helper'

class StaticPageTest < ActiveSupport::TestCase
  context "The StaticPage class" do
    setup do
      Factory(:static_page)
    end

    should     allow_mass_assignment_of(:title)
    should     allow_mass_assignment_of(:body)
    should     allow_mass_assignment_of(:slug)
    should_not allow_mass_assignment_of(:id)
    should_not allow_mass_assignment_of(:created_at)
    should_not allow_mass_assignment_of(:updated_at)

    should validate_presence_of(:title)
    should validate_presence_of(:body)
    should validate_presence_of(:slug)

    should validate_uniqueness_of(:title).case_insensitive
    should validate_uniqueness_of(:slug)
  end

  context "A StaticPage instance" do
    setup do
      @page = Factory(:static_page)
    end

    should "produce its slug when calling to_param" do
      assert_equal @page.slug, @page.to_param
    end

    should "produce HTML when calling body_html" do
      assert_equal RedCloth.new(@page.body).to_html, @page.body_html
    end

    should "produce a formatted date string when calling published_at" do
      assert_equal @page.created_at.strftime("%B %d, %Y"), @page.published_at
    end
  end
end
