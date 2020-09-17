# Ruby wrapper for Apicalypse

[What is Apicalypse?](https://apicalypse.io/)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ruby-apicalypse'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ruby-apicalypse

## Usage

### Raw Apicalypse

```ruby
rawQueryString = "fields a,b,c;limit 50;offset 0;";

Apicalypse.new("https://myapi.com/foobar")
  .query(rawQueryString)
  .request
```

### Apicalypse Query Builder

```ruby
api = Apicalypse.new("https://myapi.com/foobar")

api
  .fields(:name, :movies, :age) # fetches only the name, movies and age fields
  .limit(50) # limit to 50 results
  .offset(10) # offset results by 10
  .sort(:name) # default sort direction is 'asc' (ascending)
  .sort(:name, :desc) # sorts by name, descending
  .search("Arnold") # search for a specific name (search implementations can vary)
  .where("age > 50 & movies != n") # filter the results

api.request
```

Learn more about the Apicalypse syntax [here](https://apicalypse.io/syntax/).

### Optional configurations

By default, the apicalypse query method is put in the request body. If your server doesn't support GET bodies, you can put the request in the URL as instead.

```ruby
# Raw
Apicalypse.new("https://any-apicalypse-api.com/foobar", {
  queryMethod: :url
})
  .query("limit=50&fields=name")
  .request

# Scoped
Apicalypse.new("https://any-apicalypse-api.com/foobar", {
  queryMethod: :url
})
  .limit(50)
  .fields(:name)
  .request
```

Both examples will request `https://any-apicalypse-api.com/foobar?limit=50&fields=name`.

You can also pass custom request headers.

```ruby
Apicalypse.new("https://any-apicalypse-api.com/foobar", {
  headers: {
    'client-id' => 'your-client-id',
    'Accept'   => 'application/json'
  }
})
  .search('Json Born')
  .request
```

### Real world example
To get access to the IGDB API, please (see their documenation)[https://api-docs.igdb.com/#the-basics]

```ruby
api_endpoint = 'https://api.igdb.com/v4/games'
request_headers = { headers: { 'client-id' => 'your-twitch-client-id', 'authorization' => 'Bearer your-app-access-token', 'x-user-agent' => 'ruby-apicalypse' } }

api = Apicalypse.new(api_endpoint, request_headers)

api
  .fields(:name, :total_rating)
  .where(category: 1)
  .search('Call of Duty')
  .limit(2)
  .request

# api response

[
  {"id"=>107299, "name"=>"Call of Duty: WWII - Shadow War", "total_rating"=>75.0},
  {"id"=>57700, "name"=>"Call of Duty: Infinite Warfare - Retribution", "total_rating"=>60.0}
]
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ad2games/ruby-apicalypse. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
