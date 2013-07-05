Laserchicken
============

A RSS reader web application built on Rails.

Conceived as a replacement for the late [Google Reader][], and as such it can import your subscriptions from [backups][] (which you can still get until 12PM PST July 15, 2013).

Find Laserchicken on https://github.com/tilboerner/laserchicken .

[Google Reader]: http://en.wikipedia.org/wiki/Google_Reader
[backups]: https://www.google.com/takeout/#custom:reader "Google Reader backups"


## Features


Growth Status: _fledgling_ (alpha)

### can:

* multi-user
* subscribe to feeds
* read and star entries
* filter by new and starred
* import subscriptions from XML
* responsive layout to support mobile devices

### pending:

* keyboard shortcuts
* import stars and likes from Google Reader JSON
* shinier UI
* search (?)

### version:

For the time being, the HEAD commit on https://github.com/tilboerner/laserchicken is considered the project version.

## You need

* Ruby 1.9.3 or above, **Ruby 2.0** preferred  
    * (includes RubyGems in standard library)
* **Bundler** http://bundler.io
* **Rails 4.0** (!) http://rubyonrails.org


## How to...

### Setup

    $ git clone https://github.com/tilboerner/laserchicken.git
    $ cd laserchicken
    $ bundle install
    $ rake db:setup
    $ rails server
    $ firefox http://localhost:3000
    
### Update feeds

Admin users can trigger manual updates from the web interface. The updating is done by a *rake* task, however, so you can get **automatic updates** by scheduling

    $ rake update_active_feeds
    
to run regularly in the application dir.

### Import subscriptions

If you have a subscription list in OPML format, like, say, from your prior [Google Reader][] account, you can import them for your user by running:

    $ rake import_subscriptions_from_opml \
    > OPML_SOURCE=path/to/subscriptions.xml \
    > USER_NAME=your_username

(You can still get Google Reader [backups][] until 12PM PST July 15, 2013.)

### Run in production environment

Rails knows at least three different modes to operate in: *development*, *test*, and *production*. The above instructions should have happened in *development* by default, which is fine while working on the application locally. Running in *production* gives you speed and efficiency (among other things), so if you're done evaluating, you'll want to do that.

To **get production mode**, simply arrange for `$RAILS_ENV` to contain the name of the wanted environment: `RAILS_ENV=production`. You can also start the server with `rails server -e production`.

Since there are different databases for every environment, you need to `rake db:setup` again with the production environment set. If the content of the development DB is dear to you, just copy it to production: 

    $ cp db/development.sqlite3 db/production.sqlite3

(This assumes that you intent to use *SQLite3* for your production database, too.)

If you don't have the `rails server` running behind another web server and want it to serve the static assets for you (like CSS or JavaScript files), you may want to open 

    config/environments/production.rb

and have a look at `config.serve_static_assets` and `config.assets.compile`. Otherwise, relevant files will not get out to the client.

### Learn about Rails

Try out `rails console` and `rails console --sandbox`. 

Reading material, in order of in-depth-ness:

- [Getting Started](http://guides.rubyonrails.org/getting_started.html)
- [Rails Guides](http://guides.rubyonrails.org/)
- [Rails Tutorial](http://ruby.railstutorial.org/ruby-on-rails-tutorial-book?version=4.0) (it's a whole book, also available online)
- [API doc](http://api.rubyonrails.org/).

## License

(The MIT License)
 
Copyright (c) 2013: Tilman Börner (tilman.boerner@gmx.net)

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:
 
The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.
 
THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

Based on *Ruby on Rails* and *Feedzirra*, also released under the MIT License.
