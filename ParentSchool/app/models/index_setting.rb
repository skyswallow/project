class IndexSetting < ActiveRecord::Base
  IS_ONLINE = {:TRUE => true, :FALSE => false} #发布状态 0-预览 1-发布
end
