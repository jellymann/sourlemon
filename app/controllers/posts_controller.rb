class PostsController < ApplicationController
  before_action :check_user_auth, except: [:index, :show]

  def index
    @posts = Post.published.order('published_at DESC')
  end

  def show
    date = Date.parse("#{params[:year]}-#{params[:month]}-#{params[:day]}")
    @post = Post.published.where('published_at >= ? and published_at <= ? and slug = ?', date, date + 1.day, params[:slug]).first
    raise ActionController::RoutingError.new('Not Found') if @post.nil?
  end

  def new
    @post = Post.new
  end

  def edit
    @post = find_post
  end

  def create
    @post = create_post

    if @post.save
      redirect_to slug_path(@post), notice: 'Post was successfully created.'
    else
      render :new
    end
  end

  def update
    @post = find_post
    if @post.update(post_params_with_tags)
      redirect_to slug_path(@post), notice: 'Post was successfully updated.'
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
      params.require(:post).permit(:title, :body, :tags_csv, :published, :published_at)
    end

    def post_params_with_tags
      post_params.dup.tap { |p|
        p[:tags] = p[:tags_csv].split(',').map(&:strip) if p[:tags_csv]
      }
    end

    def create_post
      import = params[:post][:import]
      return Post.new(post_params_with_tags) if import.nil?
      Post.from_jekyll(import.read)
    end

    def check_user_auth
      raise ActionController::RoutingError.new('Not Found') unless user_signed_in?
    end
end
