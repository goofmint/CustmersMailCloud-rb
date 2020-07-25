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

### Send email

```ruby
json = client.send
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/customers_mail_cloud. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/customers_mail_cloud/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the CustomersMailCloud project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/customers_mail_cloud/blob/master/CODE_OF_CONDUCT.md).
