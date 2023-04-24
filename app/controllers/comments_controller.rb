class CommentsController < ApplicationController
    before_action :set_article

    def create
        if user_session.present?
            @article.comments.create(comment_params.to_h.merge!({ user_id: current_user.id }))
        else
            @article.comments.create(comment_params.to_h.merge!({ user_id: 1 }))
        end

        redirect_to article_path(@article), notice: 'Comment was successfully created.'    
    end

    def destroy
        comment = @article.comments.find(params[:id])
        authorize comment

        comment.destroy
        redirect_to article_path(@article), notice: 'Comment was successfully deleted.'
    end
        
    private 

    def set_article
        @article = Article.find(params[:article_id])
    end
    
    def comment_params
        params.require(:comment).permit(:body)
    end
    
end
