class Resource < ActiveRecord::Base
   
  has_attached_file :attachment,
    :path => ":rails_root/public/uploads/:class/:attachment/:id/:basename.:extension",
    :url => "/uploads/:class/:attachment/:id/:basename.:extension"

  def self.find_by_type(type_id, num)
    return self.find(:all, :conditions => ["resource_type = ?", type_id], :limit => num, :order => "created_at desc")
  end

  def self.find_new_resources(num)
    return self.find(:all, :limit => num, :order => "created_at desc")
  end

  def self.find_hot_resources(num)
    return self.find(:all, :limit => num, :order => "downloads desc")
  end


  GRADE= [[1,"小学"],[2,"中学"],[3,"高中"]]

  def Resource.new_resource(type)
    if type==1
      grade_type=1 #1是resource_type.parent_id ,代表小学
    elsif type==2
      grade_type=6 #6是resource_type.parent_id , 代表中学
    else
      grade_type=17 #19是resource_type.parent_id , 代表高中
    end
    joins = "left join resource_types s on resource_type=s.id"
    conditions = ["s.parent_id=?",  grade_type]
    Resource.find :all,
      :conditions => conditions,
      :joins => joins,
      :order => "created_at desc",
      :limit => 10
  end
end
