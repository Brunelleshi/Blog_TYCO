class CommentsController < ApplicationController
    before_action :set_article

    def create
        if user_session.present?
            @article.comments.create(comment_params.to_h.merge!({ user_id: current_user.id }))
        else
            # user_id: 4 = unknow@email.com
            @article.comments.create(comment_params.to_h.merge!({ user_id: 4 }))
        end

        redirect_to article_path(@article), notice:  t('app.create.success', model: Comment.model_name.human)    
    end

    def destroy
        comment = @article.comments.find(params[:id])
        authorize comment

        comment.destroy
        redirect_to article_path(@article), notice:  t('app.destroy.success', model: Comment.model_name.human)
    end
        
    private 

    def set_article
        @article = Article.find(params[:article_id])
    end
    
    def comment_params
        params.require(:comment).permit(:body)
    end
    
end
