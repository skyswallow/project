class NetClassesController < ApplicationController
  layout "default"

  def index
    @index_hash = Hash.new
    @settings = IndexSetting.all
    @settings.each do |setting|
      @index_hash[setting.code] = setting.online_file_path
    end
  end
  
end
