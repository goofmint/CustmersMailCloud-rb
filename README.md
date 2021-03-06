# CustomersMailCloud

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'customers_mail_cloud'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install customers_mail_cloud

## Usage

### Initialize

```ruby
client = CustomersMailCloud::Client.new(api_user, api_key)
```

### Set mail information

```ruby
client.from = CustomersMailCloud::MailAddress.new('info@smtps.jp', 'Admin')
client.trial
client.to << CustomersMailCloud::MailAddress.new('test@smtps.jp', 'Tester')
client.subject = 'Mail subject'
client.text = 'Mail body'
```

### Attach file(s)

```ruby
# File path by sting
client.attachments << "./Rakefile"
# File object
client.attachments << open("./test.rb")
```

### Send email

```ruby
json = client.send
```

## Get Transaction

### Get bounce

```ruby
bounce = @client.bounce
bounce.server_composition = 'sandbox'
bounce.start_date = Date.parse("2020-11-20")
bounce.limit = 100
bounce.list
```

### Get delivery

```ruby
delivery = @client.bounce
delivery.server_composition = 'sandbox'
delivery.date = Date.parse("2020-11-20")
delivery.limit = 100
delivery.list
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/customers_mail_cloud. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/customers_mail_cloud/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the CustomersMailCloud project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/customers_mail_cloud/blob/master/CODE_OF_CONDUCT.md).
