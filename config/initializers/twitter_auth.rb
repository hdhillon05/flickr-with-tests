Rails.application.config.middleware.use OmniAuth::Builder do 
  provider :twitter, ENV["TWITTER_PK"], ENV["TWITTER_SK"]
end