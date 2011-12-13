# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include Constant, Authenticated, Page_history
  helper :all # include all helpers, all the time
  before_filter :set_privacy

#  before_filter :set_online_users
  
  protect_from_forgery  :secret => '37644117eca76a55c6cb4bc8e474c24f'

  def proof_code(len)
    chars = ('1'..'9').to_a
    code_array = []
    1.upto(len) {code_array << chars[rand(chars.length)]}
    return code_array.to_s
  end

  private
  def set_privacy
    @controller_path = self.controller_path
    @controller_name = self.controller_name
    response.headers["P3P"]=%|CP="NOI DSP COR NID ADMa OPTa OUR NOR"|
  end

  def activity_exist(activity)
    if activity
      yield(activity)
    else
      flash[:warn] = "该活动不存在！"
    end
  end

  def set_online_users
    flag = 0
    if request.url.match("/admin/").nil?
      online_users = OnlineUser.find_all_by_client_ip_and_status request.remote_ip, 0
      (online_users || []).each do |online_user|
        if cookies[:space_id]
          if cookies[:space_id] == online_user.space_id
            if 30.minutes.ago.strftime("%Y%m%d%H%M%S").to_i - online_user.updated_at.strftime("%Y%m%d%H%M%S").to_i > 0
              #              Space.find_by_id(online_user.space_id).update_attribute(:online_status, false)
              online_user.update_attribute(:status, 1)
            else
              online_user.update_attribute(:updated_at, Time.now)
            end
          end
        end
      end
      if cookies[:space_id]
        user = OnlineUser.find_by_space_id(cookies[:space_id])
        if user and request.url.match("/community/sessions/").nil?
          if user.status.to_i == 1
            cookies.delete(:space_id, :domain => "xuexi6.com")
            cookies.delete(:passport, :domain => "xuexi6.com")
            cookies.delete(:nickname, :domain => "xuexi6.com")
            cookies.delete :space_id
            cookies.delete :passport
            flag = 1
          elsif user.status.to_i == 0 and user.client_ip != request.remote_ip
            cookies.delete(:space_id, :domain => "xuexi6.com")
            cookies.delete(:passport, :domain => "xuexi6.com")
            cookies.delete(:nickname, :domain => "xuexi6.com")
            cookies.delete :space_id
            cookies.delete :passport
            flag = 2
          end
        end
      end
    end
    if flag ==1
      redirect_to "/home?login_type=1"
    elsif flag ==2
      redirect_to "/home?login_type=2"
    end
  end
end
