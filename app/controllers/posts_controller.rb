class PostsController < ApplicationController
  before_filter :check_user_auth, except: [:index, :show]

  def index
    @posts = Post.published.order('published_at DESC')
  end

  def show
    date = Date.parse("#{params[:year]}-#{params[:month]}-#{params[:day]}")
    @post = Post.published.where('published_at >= ? and published_at <= ? and slug = ?', date, date + 1.day, params[:slug]).first
  end

  def new
    @post = Post.new
  end

  def edit
    @post = find_post
  end

  def create
    @post = Post.new(post_params_with_tags)

    if @post.save
      redirect_to @post.slug_url, notice: 'Post was successfully created.'
    else
      render :new
    end
  end

  def update
    @post = find_post
    if @post.update(post_params_with_tags)
      redirect_to @post.slug_url, notice: 'Post was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    find_post.destroy
    redirect_to root_url, notice: 'Post was successfully destroyed.'
  end

  private
    def find_post
      Post.find(params[:id])
    end

    def post_params
      params.require(:post).permit(:title, :body, :tags_csv)
    end

    def post_params_with_tags
      post_params.dup.tap { |p|
        p[:tags] = p[:tags_csv].split(',').map(&:strip)
      }
    end

    def check_user_auth
      raise ActionController::RoutingError.new('Not Found') unless user_signed_in?
    end
end
