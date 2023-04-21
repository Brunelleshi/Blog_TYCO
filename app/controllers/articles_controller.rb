class ArticlesController < ApplicationController
    #id do artigo
    def index
        @articles = Article.all    
    end

    #abre o artigo
    def show
        @article = Article.find(params[:id])
    end

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
    def edit
        @article = Article.find(params[:id])        
    end
    
    #salva a edição do artigo
    def update
        @article = Article.find(params[:id])
        if @article.update(article_params)
            redirect_to @article
        else
            render :edit
        end    
    end
    

    private
    #verifica se o artigo esta dentro das regras para ser postado
    def article_params
        params.require(:article).permit(:title, :body)      
    end

end
