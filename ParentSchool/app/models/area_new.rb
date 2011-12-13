class AreaNew < ActiveRecord::Base

  AREA = [[1,"崇川区"],[2,"港闸区"],[3,"开发区"],[4,"通州"],[5,"海门"],[6,"启东"],[7,"如皋"],[8,"如东"],[9,"海安"]]

  named_scope :news, lambda { |space_id| { :conditions => ["area_id = ?", AreaManager.find_by_space_id(space_id).area_id] }}
  named_scope :order_by, lambda { |order| { :order => order }}

  def self.top(area_id,num)
    AreaNew.find_by_sql("select * from (select * from area_news n where n.area_id = #{area_id} order by n.created_at desc) where rownum <= #{num} ")
  end

  def self.area_name(area_id,type)
    r = AREA[area_id - 1][1] if area_id != 0 and area_id !=10
    if (area_id == 0 or area_id == 10) or type.to_i == 1
      r = "搜索结果"
    end
    return r
  end
end
