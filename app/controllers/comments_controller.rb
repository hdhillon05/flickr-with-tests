class CommentsController < ApplicationController
  before_action :require_current_user
  
  def index
    render text: "coming soon"
  end

  #Note: I commented this out because decided to show comment field in the show page for photos - notice that the test still works under comments_controller_test
  # def new
  #    @photo = Photo.find(params[:photo_id])
  #    @comment = Comment.new
  # end

  def create
    @comment = Comment.new(comment_params)
    @comment.commentable = Photo.find(params[:photo_id])
    @comment.user = @current_user
    @comment.save
    redirect_to photo_path(@comment.commentable)
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

end
