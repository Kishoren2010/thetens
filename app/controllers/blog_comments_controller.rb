class BlogCommentsController < ApplicationController
  before_filter :authenticate_user!, except: [:index, :show]
  before_action :set_blog_comment, only: [:show, :edit, :update, :destroy]

  # GET /blog_comments
  # GET /blog_comments.json
  #def index
  #  @blog_comments = BlogComment.all
  #end

  # GET /blog_comments/1
  # GET /blog_comments/1.json
  #def show
  #end

  # GET /blog_comments/new
  #def new
  #  @blog_comment = BlogComment.new
  #end

  # GET /blog_comments/1/edit
  #def edit
  #end

  # POST /blog_comments
  # POST /blog_comments.json
  def create
    @post = Post.find(params[:post_id])
    @blog_comment = @post.blog_comments.create(params[:blog_comment])
    @blog_comment.user = current_user

    MyMailer.blog_alert(@post.user).deliver

    respond_to do |format|
      if @blog_comment.save
        format.html { redirect_to @post, notice: 'Blog comment was successfully created.' }
        format.json { render action: 'show', status: :created, location: @blog_comment }

        @blog_commenter = @post.blog_comments.collect(&:user)
        @blog_commenter = @blog_commenter.uniq
        
        @blog_commenter.each do |blog_commenter|  
          if blog_commenter != @post.user || blog_commenter != @blog_comment.user
            MyMailer.blog_commenter_email(blog_commenter).deliver
          end  
        end  

      else
        format.html { render action: 'new' }
        format.json { render json: @blog_comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /blog_comments/1
  # PATCH/PUT /blog_comments/1.json
  #def update
  #  respond_to do |format|
  #    if @blog_comment.update(blog_comment_params)
  #      format.html { redirect_to @blog_comment, notice: 'Blog comment was successfully updated.' }
  #      format.json { render action: 'show', status: :ok, location: @blog_comment }
  #    else
  #      format.html { render action: 'edit' }
  #      format.json { render json: @blog_comment.errors, status: :unprocessable_entity }
  #    end
  #  end
  #end

  # DELETE /blog_comments/1
  # DELETE /blog_comments/1.json
  def destroy
    @blog_comment = BlogComment.find(params[:id])
    @blog_comment.destroy
    respond_to do |format|
      format.html { redirect_to blog_comments_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_blog_comment
      @blog_comment = BlogComment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def blog_comment_params
      params.require(:blog_comment).permit(:post_id, :body)
    end
end
