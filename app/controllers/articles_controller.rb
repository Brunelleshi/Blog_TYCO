class ArticlesController < ApplicationController
    include Paginable 

    before_action :set_article, only: %i[edit update destroy]
    before_action :authenticate_user!, except: %i[index show]
    before_action :set_categories, only: %i[index new create edit update]
    
    def index
        @archives = Article.group_by_month(:created_at, format: '%B %Y', locale: :en).count
        
        category = @categories.find { |c| c.name == params[:category] } if params[:category].present?
        month_year = @archives.find { |m| m[0] == params[:month_year] }&.first if params[:month_year].present?

        @highlights = Article.includes(:category, :user)
                    .filter_by_category(category)
                    .filter_by_archive(month_year)
                    .desc_order.first(3)
                    
        highlights_ids = @highlights.pluck(:id).join(',')

        @articles = Article.includes(:category, :user)
                    .without_highlights(highlights_ids)
                    .filter_by_category(category)
                    .filter_by_archive(month_year)
                    .desc_order.page(current_page)
    end

    #abre o artigo
    def show
        @article = Article.includes(comments: :user).find(params[:id])
        authorize @article
    end

    #cria um artigo
    def new
        @article = current_user.articles.new
    end

    #salva o novo artigo
    def create
        @article = current_user.articles.new(article_params)
        if @article.save
            redirect_to @article, notice: t('.success')
        else
            render :new
        end
    end

    #permite a edição do artigo
    def edit; end
    
    #salva a edição do artigo
    def update
        if @article.update(article_params)
            redirect_to @article, notice: t('.success')
        else
            render :edit
        end    
    end
    
    #exclui o artigo
    def destroy
        @article.destroy        
        redirect_to root_path, notice: t('.success')
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

    def set_categories
        @categories = Category.sorted
    end

end
