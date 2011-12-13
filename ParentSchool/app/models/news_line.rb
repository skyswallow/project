class NewsLine < ActiveRecord::Base
  #状态
  STATUS = {
    :NEW => 0,  #未发布
    :NOMAL => 1  #已发布
  }

  #新闻综合的推荐状态
  IS_RECOMMENDED = {
    :NO => 0,   #未推荐
    :YES => 1   #已推荐
  }


  #输入type_id,获得news_type的名称,如果输入了sub_type_id，获得子分类的名称 ，如果没有，返回nil
  def NewsLine.news_type(type_id,sub_type_id=nil)
    NewsLine::TYPES.each_value do |value|
      if sub_type_id
        value[:sub_type].each_value do |sub_value|
          return sub_value[:name] if sub_value[:id] == sub_type_id
        end
      else
        return value[:name]
      end if value[:id] == type_id
    end
    return nil
  end

  #输入type_id,返回sub_type,如果没有sub_type,返回nil
  def NewsLine.sub_type(type_id)
    NewsLine::TYPES.each_value do |value|
      return value[:sub_type] if value[:id] == type_id
    end
  end

  def NewsLine.newest(type,limit=9,sub_type=nil)
    joins = "left join news_types s on news_type=s.id"
    conditions = ["status=? and s.parent_id=?", NewsLine::STATUS[:NOMAL], type]
    if sub_type
      conditions[0] << " and news_type = ?"
      conditions << sub_type
    end
    NewsLine.find :all, :conditions => conditions,
      :joins => joins,
      :order => "created_at desc",:limit => limit
  end

  def NewsLine.zhengce
    conditions =["status=? and news_type=?", NewsLine::STATUS[:NOMAL], 12]
    NewsLine.find :all,
      :conditions => conditions,
      :order => "created_at desc",
      :limit => 8
  end

  #根据页面返回数据库中不同的数据
  def NewsLine.infolist(id,limitnum,is_recommended=nil)
    conditions = ["status=? and news_type=?", NewsLine::STATUS[:NOMAL],id ]
    if(is_recommended==1)
      conditions[0] << " and is_recommended = 1"
    elsif(is_recommended==0)
      conditions[0] << " and is_recommended = 0"
    end
    NewsLine.find :all, :conditions => conditions,
      :order => "created_at desc",:limit => limitnum
  end

  def NewsLine.infolistnew(type,limitnum,is_recommended=nil)
    joins = "left join news_types s on news_type=s.id"
    conditions = ["status=? and s.parent_id=? ", NewsLine::STATUS[:NOMAL],type ]
    if(is_recommended==1)
      orders = "recommended_at desc"
      conditions[0] << " and is_recommended = 1"
    elsif(is_recommended==0)
      orders = "created_at desc"
      conditions[0] << " and is_recommended = 0"
    end
    NewsLine.find(:all, :conditions => conditions,
      :joins => joins,
      :order => orders,:limit => limitnum)
  end

  def self.index_news
    t = NewsType.find_all_by_parent_id(1).collect { |e| e.id.to_s }
    y = ""
    (t || []).each do |id|
      y << id + ","
    end
    types = y[0,y.length - 1]
    lines = NewsLine.find_by_sql(["SELECT news_lines.id,news_lines.path,news_lines.summary,news_lines.created_at,news_lines.title,news_lines.head_image,spaces.nickname
      FROM news_lines  left join spaces on spaces.id=news_lines.created_by
      WHERE (news_lines.status=#{NewsLine::STATUS[:NOMAL]} and news_lines.news_type in (#{types}) and news_lines.is_recommended =#{NewsLine::IS_RECOMMENDED[:YES]})
      ORDER BY news_lines.recommended_at desc"])
    lines1 = NewsLine.find_by_sql(["SELECT news_lines.id,news_lines.path,news_lines.summary,news_lines.created_at,news_lines.title,news_lines.head_image,spaces.nickname
      FROM news_lines  left join spaces on spaces.id=news_lines.created_by
      WHERE (news_lines.status=#{NewsLine::STATUS[:NOMAL]} and news_lines.news_type in (#{types}) and news_lines.is_recommended =#{NewsLine::IS_RECOMMENDED[:NO]})
      ORDER BY created_at desc"])
    lines += lines1
    x = []
    if lines.size > 7
      x = lines[0...7]
    else
      x = lines
    end
    return x
  end
  
end
