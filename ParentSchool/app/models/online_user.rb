class OnlineUser < ActiveRecord::Base
  establish_connection :xuexi
  #status = 0, 1 # 0:在线，1：离线
end
