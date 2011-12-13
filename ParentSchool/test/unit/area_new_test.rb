require File.dirname(__FILE__) + '/../test_helper'

class AreaNewTest < ActiveSupport::TestCase

  def test_area_name
    area_new1 = AreaNew.area_name(10, '1')
    assert_equal "搜索结果", area_new1
    area_new2 = AreaNew.area_name(5, '0')
    assert_equal "海门", area_new2
    area_new3 = AreaNew.area_name(3, '0')
    assert_equal "开发区", area_new3
    area_new4 = AreaNew.area_name(9, '0')
    assert_equal "海安", area_new4
    area_new5 = AreaNew.area_name(9, '1')
    assert_equal "搜索结果", area_new5
  end

end
