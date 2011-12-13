class LecturesController < ApplicationController
  layout "default"
 
  def show
    @lectures = Lecture.all(:order =>"created_at desc")
    @lecture = Lecture.find_by_id(params[:id])
    if @lecture
      session[:proof_code1] = proof_code(4)
      @comments = LectureComment.find_all_by_lecture_id @lecture.id, :order => "created_at desc"
    else
      flash[:warn] = "该讲座不存在！"
      redirect_to "/"
    end
  end

  def get_proof_code
    session[:proof_code1] = proof_code(4)
    render :inline => session[:proof_code1]
  end

  def create
    lecture = Lecture.find_by_id(params[:lecture_id])
    @error_info = ""
    if lecture
      if params[:proof_code1] and params[:proof_code1].strip == ""
        @error_info += "验证码不能为空！<br/>"
      elsif params[:proof_code1].downcase != session[:proof_code1].to_s.downcase
        @error_info += "您输入的验证码不正确，请重新输入！<br/>"
      end
      if params[:content] and params[:content].strip == ""
        @error_info += "评论内容不能为空！<br/>"
      elsif params[:content] and params[:content].strip != "" and params[:content].to_s.split(//).length > 500
        @error_info += "评论内容长度不能超过500！<br/>"
      end      
      if params[:user_name] and params[:user_name].strip != "" and params[:user_name].to_s.split(//).length > 20
        @error_info += "发表人长度不能超过20！<br/>"
      end
      if @error_info == ""
        comment = LectureComment.new
        if params[:user_name] and params[:user_name].strip != ""
          comment.name = params[:user_name].strip
        else
          if cookies[:space_id]
            comment.name = "匿名"
          else
            comment.name = "游客"
          end
        end
        comment.content = params[:content]
        comment.created_ip = request.remote_ip
        comment.created_at = Time.now
        comment.lecture_id = params[:lecture_id]
        comment.save
      end
      @comments = LectureComment.find_all_by_lecture_id lecture.id, :order => "created_at desc"
      render  :partial =>"list_comment"
    else
      render :js =>"<script>alert('该讲座不存在！');window.location='/';</script>"
    end
  end

  def destroy
    comment = LectureComment.find_by_id params[:id]
    lecture = Lecture.find_by_id comment.lecture_id if comment
    if lecture
      comment.destroy if comment
      @comments = LectureComment.find_all_by_lecture_id lecture.id, :order => "created_at desc"
      render  :partial =>"list_comment"
    else
      render :js =>"<script>alert('该讲座不存在！');window.location='/';</script>"
    end
  end

end