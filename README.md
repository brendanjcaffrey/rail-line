# Rail Line #

Rail Line is a simple iPhone app built with [RubyMotion](http://www.rubymotion.com) for CTA train commuters.

## Building

You'll need to request a [CTA Train Tracker API Key](http://www.transitchicago.com/developers/ttkey.aspx). Once you have that, create `app/secrets.rb` and add this to it:

```ruby
class Secrets
  def self.api_key
    'YOUR KEY HERE'
  end
end
```

Then, run `bundle install` and `rake` to install dependencies and run the application.
