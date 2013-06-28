desc "Update a feed"
task :update_feed => :environment do
  feed = Feed.find(ENV['FEED_ID'])
  feed.fetch
end

desc "Update all subscribed feeds"
task :update_active_feeds => :environment do
  for feed in Feed.active do
    feed.fetch
  end
end
