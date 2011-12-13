module Admin::ResourcesHelper

  def find_top
    return ResourceType.find_top.collect{|item|[item.name, item.id]}.insert(0, ["请选择...", 0])
  end
  
end