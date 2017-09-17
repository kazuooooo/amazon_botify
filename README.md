# AmazonBotify

Make your amazon account a useful chatbot like below!! (Currently Japanse Only. Welcome to PR :))

* Howto use
![howto](https://qiita-image-store.s3.amazonaws.com/0/71154/bf96e6c1-88d2-4090-7993-d201b74a839f.png "howto")

* Add product
![add_product](https://qiita-image-store.s3.amazonaws.com/0/71154/e5738fc9-a251-e35f-2143-47fa8c6cb01e.png
 "add_product")

* Delete product
![delete_product](https://qiita-image-store.s3.amazonaws.com/0/71154/747ea81b-3b90-7c37-3015-36e654818882.png
 "delete_product")

* Refer Products List
![refer_product_list](https://qiita-image-store.s3.amazonaws.com/0/71154/daa74fd9-807e-5253-5c83-a89bac5cc28f.png
 "refer_product_list")

* Order Product(return confirmation screeen shot)
![order_product](https://qiita-image-store.s3.amazonaws.com/0/71154/d21f2951-40e0-bf57-641c-c2f8f6a1b062.png
 "order_product")
 
* Refer History
![refer_order_history](https://qiita-image-store.s3.amazonaws.com/0/71154/509e01ef-d36d-d777-7141-fcea707ac1d4.png
 "refer_order_history")
 



## Requirement
* Ruby 2.4.0 or higher
* SeleniumWebdriver(default [chrome](https://sites.google.com/a/chromium.org/chromedriver/downloads))
* PC for LocalServer(You can't use headless browser because of recaptcha ;( )
* Some Messenger Accont(Now Available Only [Slack](https://www.google.co.jp/search?q=slack&hl=en&lr=lang_en))
* [ngrok](https://ngrok.com/)


## GettingStarted
System structure is below
![system.png](https://qiita-image-store.s3.amazonaws.com/0/71154/f9cbefc6-2e2e-0469-2f27-758706f3ce32.png)

First, bundle install and setup database
```sh
bundle install
bundle exec rake db:create
bundle exec rake db:migrate
```
Then,  setup your amazon accont to environment variables

```sh
export AMAZON_BOT_EMAIL="your_account@your_domain.com"
export AMAZON_BOT_PASSWORD="your_password"
export AMAZON_BOT_SLACK_TOKEN="your_slack_token" # if you use slackma
export AMAZON_BOT_DOMAIN="www.amazon.co.jp"
```

start app

```sh
bundle exec rackup
```

connect with ngrok

```sh
ngrok http 9292 #sinatra port
```

then,  connect your messanger and sinatra endpoint(※All Post Method)

| Command | Endpoint |
|:-----------|:------------|
| Howto use  | /howto      |
| Add product     |  /products      |
| Delete product       |  /delete_products        |
|  Refer products List         |  /products_list          |
| Order Product       | /products       |
| Refer History    |  /order_index     |


For example howto command can be set as Outgoing webhook like this.
![og_hook.png](https://qiita-image-store.s3.amazonaws.com/0/71154/1bca830a-b0f5-74f1-d231-1583ea8efe61.png)

Now, you made it!!

# For other messenger

Now, this app can compatible with only slack.

If you want to use other messenger, you can do it by creating custom bot class.
Only You need to implement is send_message method.

```ruby
module Bot
  class CustomBot < BotBase
    # required
    def send_message(message)
      some_messanger_client.send_message(message)
    end
  end
end
```

