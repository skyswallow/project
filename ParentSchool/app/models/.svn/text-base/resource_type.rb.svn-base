class ResourceType < ActiveRecord::Base

  IS_PARENT = '0'

  XIAOXUE = '1' # 小学
  CHUZHONG = '6' # 初中
  GAOZHONG = '17' # 高中

  # 得到顶级分类
  def self.find_top
    return self.find(:all, :conditions => ["parent_id = ?", IS_PARENT], :order => "to_number(id)")
  rescue
    return []
  end

  # 根据顶级分类的id得到所有下级分类
  def self.find_by_parent_id(parent_id)
    return self.find(:all, :conditions => ["parent_id = ?", parent_id], :order => "to_number(id)")
  rescue
    return []
  end

  # 根据id得到分类名称
  def self.find_parent_name(type_id)
    return self.find_by_id_and_parent_id(type_id, IS_PARENT).name
  rescue
    return ""
  end
  
end
