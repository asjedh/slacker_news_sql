require 'sinatra'
require 'csv'
require 'pry'
require 'pg'
### METHODS


def db_conn
  begin
    connection = PG.connect(dbname: 'slacker_news')
    yield(connection)
  ensure
    connection.close
  end
end

def save_article_to_db(article_info_array)
  db_conn do |conn|
    conn.exec_params("INSERT INTO articles (title, url, description)
    VALUES ($1,$2,$3)", article_info_array)
  end
end

def import_articles_from_db
  db_conn do |conn|
    conn.exec("SELECT * FROM articles")
  end.to_a
end



### PATHS
get '/articles' do
  @articles = import_articles_from_db
  erb :home
end

get '/articles/new' do
  erb :'submit/submit', layout: :'submit/layout'
end

post '/articles/new' do
  new_article = [params[:title], params[:url], params[:description]]
  save_article_info_to_csv(new_article)
  "Thank you! You're response has been recorded!"
  redirect '/articles'
end

get '/' do
  redirect '/articles'
end

