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

desc "Import feed subscriptions from an OPML file"
task :import_subscriptions_from_opml => :environment do
  include FeedsHelper
  opml_src = ENV['OPML_SOURCE']
  user = User.find(ENV['USER_ID'])
  opml = OpmlFeed.new
  opml.parse_opml(opml_src)
  errors = {}
  for content in opml.outlines do
    begin
      url = content.outline['xmlUrl']
      feed = Feed.find_or_create_by!(feed_url: url)
      Subscription.find_or_create_by!(user: user, feed: feed)
      puts url
    rescue ActiveRecord::RecordInvalid => e
      errors[url] = e
    end
  end
  unless errors.empty?
    errors.each do |url, error|
      $stderr.puts "#{url}: #{error.to_s}"
    end
  end
end
