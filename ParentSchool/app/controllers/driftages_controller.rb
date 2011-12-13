class DriftagesController < ApplicationController

  layout "driftage"

  def add_apply
    if UserActivityRelation.is_apply(cookies[:space_id]).blank?
      UserActivityRelation.do_apply(cookies[:space_id])
       render :nothing => true
    end
  end

  def add_topic
    GroupTopicComment.add_comment(params[:content], cookies[:space_id], params[:id], 1, request.remote_ip)
    UserActivityRelation.add_point(cookies[:space_id])
    entry_category = EntryCategory.find_by_name_and_space_id("漂流活动", cookies[:space_id])
    if entry_category
    else
      entry_category = EntryCategory.create({:name => "漂流活动", :space_id => cookies[:space_id]})
    end
    Entry.add_entry(cookies[:space_id], entry_category.id, params[:id], request.referer, request.remote_ip)
    render :nothing => true
  end

  def topics
    @topics = GroupTopic.topics(params[:page], 30)
    @new_topics = GroupTopic.new_topics
    @g_topics = GroupTopic.g_topics
  end

  def show
    @topic = GroupTopic.find_by_id(params[:id])
    @topic_comments = GroupTopic.find_by_id(params[:id]).group_topic_comments.paginate :page => params[:page], :per_page => 15
    @topic_count = GroupTopic.find_by_id(params[:id]).group_topic_comments.count
    @new_topics = GroupTopic.new_topics
    @g_topics = GroupTopic.g_topics
    @book = TopicBookRelation.find_by_topic_id(params[:id]).book
  end  

  def get_infos
    sql = "select gur.role_name, us.name area, ug.name school, u.display_name, u.id from users u
inner join group_user_relations gur on u.id = gur.user_id
inner join user_groups ug on gur.user_group_id = ug.id
inner join user_groups us on ug.parent_id = us.id
where gur.role_name in ('教师', '学生') and u.target_cellphone = ?
union
select p.relation_name role_name, up.name area, ur.name school, u.display_name, u.id from users u
inner join parents p on u.id = p.id
inner join group_user_relations gur on p.student_id = gur.user_id
inner join user_groups ug on gur.user_group_id = ug.id  --班级
inner join user_groups us on ug.parent_id = us.id  --年级
inner join user_groups ur on us.parent_id = ur.id --学校
inner join user_groups up on ur.parent_id = up.id --地区
where u.target_cellphone = ?"
    @infos = User.find_by_sql([sql, params[:mobile], params[:mobile]])
    if @infos.blank?
      flash[:warn] = "您输入的手机号码不存在！"
    end
    render :action => 'forget'
  end

  def send_pass_back
    p "r"*40
    p params[:userInfo]
    flash[:notice] = "您的通行证和密码将马上发送到您的手机上，请查收！"
    redirect_to :action => 'forget'
  end

  def book_detail
    @book = BookListing.find_book_detail(params[:id])
    @articles = BookListing.find_top_articles(params[:id], params[:page])
    @group_topics_list = BookListing.find_top_group_topics(params[:id], params[:page])
  end

  def login
    flag = false
    if params[:proof_code] != session[:proof_code].to_s
      flash[:warn] = "您输入的校验码不正确，请重新输入！"
      redirect_to request.referer
    else
      if Space.find_by_passport_and_password(params[:passport], params[:password])
        space = Space.find_by_passport_and_password(params[:passport], params[:password])
      else
        user = User.find_by_username_and_password(params[:passport], params[:password])
        if user
          flag = true
          if Space.find_by_user_id(user.person_id)
            space = Space.find_by_user_id(user.person_id)
          end
        end
      end
      if space and (space.is_active == true) and (space.status == 1)
        online_user = OnlineUser.find_by_space_id(space.id)
        if online_user and online_user.client_ip != request.remote_ip and online_user.status.to_i == 0
          flash[:warn] = "用户#{space.nickname}已经处于在线状态，无法同时登录！"
          redirect_to request.referer
        else
          expire_fragment('index_page')
          Space.transaction do
            cookies[:passport] = space.passport
            cookies[:space_id] = space.id.to_s
          end
          redirect_to "#{CONFIG[:xuexi6_url]}/community/sessions/set_cookies?id=#{space.id.to_s}"
        end
      elsif space and space.is_active == false
        flash[:warn] = "您的帐户未激活！"
        redirect_to request.referer
      elsif space and space.status == 0
        flash[:warn] = "您的帐户已被锁定！"
        redirect_to request.referer
      elsif !space
        if flag
          flash[:warn] = "您输入的用户名或密码不正确,请联系客服！"
        else
          flash[:warn] = "您输入的用户名或密码不正确！"
        end
        redirect_to request.referer
      end
    end
  end

end
