class BlogsController < ApplicationController
  def index
    @blogs = Blog.all
  end

  def show
    @blog = Blog.find(params[:id])
  end

  def new

  end

  def create
    blog = Blog.new
    blog.title = params[:title]
    blog.content = params[:content]
    if blog.save
      flash[:message] = "succed!"
      redirect_to blogs_url
    else
      flash[:message] = "failed!"
      redirect_to blogs_url
    end
  end

  def edit
    @blog = Blog.find(params[:id])
  end

  def update
    blog = Blog.find(params[:id])
    blog.title = params[:title]
    blog.content = params[:content]
    if blog.save
      flash[:message] = "succed!"
      redirect_to blogs_url
    else
      flash[:message] = "failed!"
      redirect_to blogs_url
    end
  end

  def destroy
    if Blog.destroy(params[:id])
      flash[:message] = "succed!"
      redirect_to blogs_url
    else
      flash[:message] = "failed!"
      redirect_to blogs_url
    end
  end

  def find_files
    @files = Dir.glob('*')
  end

end
