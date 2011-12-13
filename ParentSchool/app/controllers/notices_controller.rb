class NoticesController < ApplicationController

  def show
    @notice = Notice.find params[:id]
    render :update do |page|
      page.replace_html "n_layer", :partial => "/home/side/notice_html"
    end
  rescue
    render :update do |page|
      page.replace_html "n_layer", :partial => "/home/side/notice_html"
    end
  end

end
