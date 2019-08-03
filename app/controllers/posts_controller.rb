class PostsController < ApplicationController

  load_and_authorize_resource
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  def index
    @user = current_user
     @post = Post.new
    posts = @user.posts.map {|post| post}
    @user.all_following.each { |user| user.posts.each{|post| posts << post } }
    @posts = (posts.sort_by! { |post| post.created_at }).reverse
    @posts = @posts.paginate(:page => (params[:page] || 1), :per_page => 10)

    respond_to do |format|
      format.html
      format.js
    end

  end

   def create
    @post = Post.new(post_params)

    respond_to do |format|
      if @post.save
        format.json { render json: @post, status: :created }
        format.html { redirect_to posts_path, notice: 'Post criado com sucesso.' }
        format.js   { render :file => "/app/views/posts/show.js.erb" }
      else
        format.json { render json: @post.errors, status: :unprocessable_entity }
        format.html { redirect_to posts_path }
      end
    end
  end

  def show
    @comment = Comment.new
    @comments = @post.comments
  end

  def destroy
    @post.destroy
 
    respond_to do |format|
      format.json { head :no_content }
      format.html { redirect_to posts_path, notice: 'Post deletado com sucesso.' }
    end
  end

  def edit
    @user = current_user
    posts = current_user.posts.map {|post| post}
    current_user.all_following.each { |user| user.posts.each{|post| posts << post } }
    @posts = posts.sort_by &:created_at

  end

  def update

    respond_to do |format|
       if @post.update(post_params)
        format.json { render json: @post, status: :created }
        format.html { redirect_to posts_path, notice: 'Post atualizado com sucesso.' }
      else
        format.json { render json: @post.errors, status: :unprocessable_entity }
        format.html { redirect_to posts_path }
      end
    end
  end

  private
 
  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
       params.require(:post).permit(:body).merge(user: current_user)
  end

end
