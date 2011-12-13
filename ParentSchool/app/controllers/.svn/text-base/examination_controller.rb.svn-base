class ExaminationController < ApplicationController
  layout "default"


  def index
    @index_hash = Hash.new
    @settings = IndexSetting.all
    @settings.each do |setting|
      @index_hash[setting.code] = setting.online_file_path
    end
    space = Space.find_by_id(cookies[:space_id]) if cookies[:space_id]
    @users = User.find_all_by_person_id_and_user_type(space.user_id, User::USER_TYPE_TEACHER) if space
  end
  
end
