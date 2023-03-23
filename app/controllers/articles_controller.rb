class ArticlesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    articles = Article.includes(:user).order(created_at: :desc)
    render json: articles, each_serializer: ArticleListSerializer
  end

def show
  article = Article.find(params[:id])

  increment_page_views
  if page_views_exceeded?
    render json: { error: "Maximum pageview limit reached" }, status: :unauthorized
  else
    render json: article
  end
end


  private

  def increment_page_views
    session[:page_views] ||= 0
    session[:page_views] += 1
  end

  def page_views_exceeded?
    session[:page_views].to_i >= 3
  end

  def record_not_found
    render json: { error: "Article not found" }, status: :not_found
  end
end
