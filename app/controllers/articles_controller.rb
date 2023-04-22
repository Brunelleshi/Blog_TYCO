class ArticlesController < ApplicationController
    before_action :set_article, only: %i[edit update show destroy]

    #seleciona o artigo
    def set_article
        @article = Article.find(params[:id])
    end
    
    def index
        current_page = (params[:page] || 1).to_i
        @articles = Article.order(created_at: :desc).page(current_page).per(3)    
    end

    #abre o artigo
    def show; end

    #cria um artigo
    def new
        @article = Article.new
    end

    #salva o novo artigo
    def create
        @article = Article.new(article_params)
        if @article.save
            redirect_to @article
        else
            render :new
        end
    end

    #permite a edição do artigo
    def edit; end
    
    #salva a edição do artigo
    def update
        if @article.update(article_params)
            redirect_to @article
        else
            render :edit
        end    
    end
    
    #exclui o artigo
    def destroy
        @article.destroy        
        redirect_to root_path
    end

    private
    #verifica se o artigo esta dentro das regras para ser postado
    def article_params
        params.require(:article).permit(:title, :body)      
    end

end
