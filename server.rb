require 'sinatra'
require 'csv'
require 'pry'
require 'pg'
require 'net/http'
require 'addressable/uri'

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
    conn.exec_params("INSERT INTO articles (title, url, description, created_at)
    VALUES ($1,$2,$3, NOW())", article_info_array)
  end
end

def import_articles_from_db
  db_conn do |conn|
    conn.exec("SELECT * FROM articles")
  end.to_a
end

SCHEMES = %w(http https)
def valid_url?(url)
  parsed = Addressable::URI.parse(url) or return false
  SCHEMES.include?(parsed.scheme)
rescue Addressable::URI::InvalidURIError
  false
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
  url = params[:url]
  if !valid_url?(url)
    @error_message = "Please enter a valid URL!"
    redirect back
  elsif #description is less than 20 char
    #error message and go back
    redirect back
  else #we're good to go... put the article in the database!

    new_article = [params[:title], params[:url], params[:description]]
    save_article_to_db(new_article)
    redirect '/articles'
  end
end

get '/' do
  redirect '/articles'
end

