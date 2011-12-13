class Notice < ActiveRecord::Base

  belongs_to :space

  def Notice.newest(limit = 20)
    find :all, :limit => limit, :order => "created_at desc"
  end
end
