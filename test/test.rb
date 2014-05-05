require 'minitest/autorun'

class TestMenuIntegration < MiniTest::Test::UnitTest
  def test_menu_prints
    assert something
  end

  def test_wrong_input_prints_menu_again
    puts "4"
    assert_includes output, menu_text
  end

  def test_wrong_input_prints_error_message
    puts "4"
    assert_includes output, "4 is not a valid selection"
  end
end

# spec style testing

describe "Menu Integration" do
  context "If the user types in the wrong input" do
    before do
      puts "4"
    end
    it "Should print the menu again" do
      output.should include(menu_text)
    end
    it "Should include an appropriate error message" do
      output.should include("4 is not a valid selection")
    end
  end
end
