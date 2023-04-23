class ArticlesController < ApplicationController
    include Paginable 

    before_action :set_article, only: %i[edit update show destroy]
    before_action :authenticate_user!, except: %i[index show]
    
    def index
        @categories = Category.sorted
        category = @categories.select { |c| c.name == params[:category] }[0] if params[:category].present?

        @highlights = Article.includes(:category, :user)
                    .filter_by_category(category)
                    .filter_by_archive(params[:month_year])
                    .desc_order.first(3)
                    
        highlights_ids = @highlights.pluck(:id).join(',')

        @articles = Article.includes(:category, :user)
                    .without_highlights(highlights_ids)
                    .filter_by_category(category)
                    .filter_by_archive(params[:month_year])
                    .desc_order.page(current_page)
                    
        @archives = Article.group_by_month(:created_at, format: '%B %Y').count
    end

    #abre o artigo
    def show; end

    #cria um artigo
    def new
        @article = current_user.articles.new
    end

    #salva o novo artigo
    def create
        @article = current_user.articles.new(article_params)
        if @article.save
            redirect_to @article, notice: "Article was successfully created."
        else
            render :new
        end
    end

    #permite a edição do artigo
    def edit; end
    
    #salva a edição do artigo
    def update
        if @article.update(article_params)
            redirect_to @article, notice: "Article was successfully updated."
        else
            render :edit
        end    
    end
    
    #exclui o artigo
    def destroy
        @article.destroy        
        redirect_to root_path, notice: "Article was successfully deleted." 
    end

    private
    #verifica se o artigo esta dentro das regras para ser postado
    def article_params
        params.require(:article).permit(:title, :body, :category_id)      
    end

    #seleciona o artigo
    def set_article
        @article = Article.find(params[:id])
        authorize @article
    end

end
