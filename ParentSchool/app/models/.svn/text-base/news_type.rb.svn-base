class NewsType < ActiveRecord::Base

  def self.get_type(parent_id)
    return self.find_by_all_by_parent_id(parent_id).sort_by { |item| item.id }
  end

  def self.get_parent_name(child_id)
    if child_id == '21' || child_id == '22'
      parent = self.find_by_id(child_id)
      return parent.name
    else
      parent = self.find_by_id(child_id)
      child = self.find_by_id(parent.parent_id) if parent and !parent.parent_id.blank?
      return child.name if child
    end
  end
end
