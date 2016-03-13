class PostsController < ApplicationController
  before_action :set_post, only: [:edit, :update, :destroy]
  before_filter :check_user_auth, except: [:index, :show]

  def index
    @posts = Post.all
  end

  def show
    date = Date.parse("#{params[:year]}-#{params[:month]}-#{params[:day]}")
    @post = Post.where('created_at >= ? and created_at <= ? and slug = ?', date, date + 1.day, params[:slug]).first
  end

  def new
    @post = Post.new
  end

  def edit
  end

  def create
    @post = Post.new(post_params)

    if @post.save
      redirect_to @post.slug_url, notice: 'Post was successfully created.'
    else
      render :new
    end
  end

  def update
    if @post.update(post_params)
      redirect_to @post.slug_url, notice: 'Post was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_url, notice: 'Post was successfully destroyed.'
  end

  private
    def set_post
      @post = Post.find(params[:id])
    end

    def post_params
      params.require(:post).permit(:title, :body)
    end

    def check_user_auth
      raise ActionController::RoutingError.new('Not Found') unless user_signed_in?
    end
end
