class App::EditorsController < ApplicationController
  #编辑器，实现编辑器的图片上传
  skip_before_filter :verify_authenticity_token
  
  #编辑器中的上传图片
  def upload_editor_image
    filename = params[:imgfile]['uploaded_data'].original_filename.split('.').reverse
    @filename = "#{rand Time.now.to_i}" + "." + filename[0]
    File.open("#{File.expand_path(RAILS_ROOT)}/public/uploads/editor/#{@filename}", "wb") do |f|
      f.write(params[:imgfile]['uploaded_data'].read)
    end
    image=MiniMagick::Image.from_file("#{File.expand_path(RAILS_ROOT)}/public/uploads/editor/#{@filename}")
    if image[:width]>450 or image[:height]>500
      pic = MiniMagick::Image.new("#{File.expand_path(RAILS_ROOT)}/public/uploads/editor/#{@filename}")
      pic.resize "450x500>"
      pic.write("#{File.expand_path(RAILS_ROOT)}/public/uploads/editor/thumb/#{@filename}")
      render :text => "<script>window.parent.LoadIMG('/uploads/editor/thumb/#{@filename}')</script>"
    else
      render :text => "<script>window.parent.LoadIMG('/uploads/editor/#{@filename}')</script>"
    end
  rescue
    render :text => "<script>window.parent.alert('您上传的图片无效或者损坏！');window.parent.divProcessing.style.display='none'; </script>"
  end
end
