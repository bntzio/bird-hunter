require 'twitter'
require 'hunting_season'
require 'httparty'

# ---------------------------------------------------------------------------------*
# 1. Configure your snipper
# ---------------------------------------------------------------------------------*
# Product Hunt
# Useful links:
# Get a developer token - https://api.producthunt.com/v1/oauth/applications
# Find a post ID - http://apps.timelinekit.com/product-hunt/search-posts
product_hunt_developer_token = 'Your Product Hunt Developer Token'
product_hunt_post_id = 6642 # Change it to your target Product Hunt post ID
votes_count = 557 # Change it to the votes number of your target Product Hunt post
#
# Twitter
# Useful links:
# Get all you need by registering a Twitter application - https://apps.twitter.com/
twitter_consumer_key = 'Your Twitter Consumer Key'
twitter_consumer_secret = 'Your Twitter Consumer Secret'
twitter_access_token = 'Your Twitter Access Token'
twitter_access_token_secret = 'Your Twitter Access Token Secret'
# ---------------------------------------------------------------------------------*


# ---------------------------------------------------------------------------------*
# 2. Load your snipper
# ---------------------------------------------------------------------------------*
tweet = "just setting up my twttr"
# ---------------------------------------------------------------------------------*


# ---------------------------------------------------------------------------------*
# 3. Fire! That's all, happy hunting! ^^ Just run the script: ruby bird_hunter.rb
# ---------------------------------------------------------------------------------*

# Note: Do not change anything below (unless you are a developer of course!)
#
# Connecting Twitter
twitter_client = Twitter::REST::Client.new do |config|
  config.consumer_key = twitter_consumer_key
  config.consumer_secret = twitter_consumer_secret
  config.access_token = twitter_access_token
  config.access_token_secret = twitter_access_token_secret
end

# Connecting Product Hunt
product_hunt_client = ProductHunt::Client.new(product_hunt_developer_token)

# Getting Product Hunt post
post = product_hunt_client.post(product_hunt_post_id)

# Setting up variables
counter = 0
skipped = 0
loops_count = (votes_count / 5.0).ceil
past_votes = nil

# Welcome intro
puts "██████╗ ██╗██████╗ ██████╗     ██╗  ██╗██╗   ██╗███╗   ██╗████████╗███████╗██████╗ "
puts "██╔══██╗██║██╔══██╗██╔══██╗    ██║  ██║██║   ██║████╗  ██║╚══██╔══╝██╔════╝██╔══██╗"
puts "██████╔╝██║██████╔╝██║  ██║    ███████║██║   ██║██╔██╗ ██║   ██║   █████╗  ██████╔╝"
puts "██╔══██╗██║██╔══██╗██║  ██║    ██╔══██║██║   ██║██║╚██╗██║   ██║   ██╔══╝  ██╔══██╗"
puts "██████╔╝██║██║  ██║██████╔╝    ██║  ██║╚██████╔╝██║ ╚████║   ██║   ███████╗██║  ██║"
puts "╚═════╝ ╚═╝╚═╝  ╚═╝╚═════╝     ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═══╝   ╚═╝   ╚══════╝╚═╝  ╚═╝"
puts "Open Source (MIT) - https://github.com/bntzio/bird-hunter"

# The Loop
while counter < loops_count do
  sleep 7
  puts counter
  if counter != 0
    votes = post.votes(per_page: 5, order: 'asc', newer: past_votes.last["id"])
    (0..votes.length-1).each do |i|
      puts "Creating tweet..."
      sleep 3
      name = votes[i]["user"]["name"]
      username = votes[i]["user"]["twitter_username"]
      if username or name == nil
        skipped += 1
        puts "Skipping... No name or username found!"
      else
        twitter_client.update("Hi #{name.split.first}! #{tweet}. @#{username}")
        puts "Boom! Tweet sent to #{name.split.first}!"
      end
    end
    past_votes = votes
  else
    votes = post.votes(per_page: 5, order: 'asc')
    (0..votes.length-1).each do |i|
      puts "Creating tweet..."
      sleep 3
      name = votes[i]["user"]["name"]
      username = votes[i]["user"]["twitter_username"]
      if username or name == nil
        skipped += 1
        puts "Skipping... No name or username found!"
      else
        twitter_client.update("Hello #{name.split.first}! #{tweet}. @#{username}")
        puts "Boom! Tweet sent to #{name.split.first}!"
      end
    end
    past_votes = votes
  end
  counter += 1
end

# Stats
puts ""
puts "******************"
puts "* Shooting Stats *"
puts "******************"
sleep 1
puts "Total: #{votes_count}"
sleep 1
puts "Succeed: #{votes_count - skipped}"
sleep 1
puts "Failed: #{skipped}"
puts "******************"
puts ""
puts "Thanks for using Bird Hunter! ^^"
puts "Created by @bntzio <hello@bntz.io>"
