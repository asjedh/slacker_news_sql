require 'sinatra'
require 'csv'
require 'pry'


def save_article_info_to_csv(article)
  CSV.open("articles_submitted.csv", "a",
            :write_headers => true,
            :headers => ["title","url","description"]) do |articles_database|
    articles_database << article
  end
end

def import_articles_database(file_path)
  articles = []
  CSV.foreach(file_path, :headers => true) do |article|
    articles << article.to_hash
  end
  articles
end

get '/' do
  @articles = import_articles_database("articles_submitted.csv")
  erb :home
end

get '/submit' do
  erb :'submit/submit', layout: :'submit/layout'
end

post '/submit' do
  new_article = [params[:title], params[:url], params[:description]]
  save_article_info_to_csv(new_article)
  "Thank you! You're response has been recorded!"
end
