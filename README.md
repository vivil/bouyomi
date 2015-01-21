Bouyomi
===

Client for [棒読みちゃん](http://chi.usamimi.info/Program/Application/BouyomiChan/), and [棒読みさん](https://github.com/sifue/bouyomisan)

### How to Use

```coffee
# create client
Client = require 'bouyomi'
client = new Client(process.env.PORT)

# connect and send data
client.connect()
client.read("hogehoge")
client.disconenct()

```
