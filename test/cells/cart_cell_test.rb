require 'test_helper'

class CartCellTest < Cell::TestCase
  test "show" do
    invoke :show
    assert_select "p"
  end
  

end
