# nexmo-crystal

Nexmo REST API client for Crystal.


## Installation

Add nexmo-crystal as a dependency in `shards.yml`:

```crystal
dependencies:
  nexmo:
    github: timcraft/nexmo-crystal.cr
    branch: master
```


## Quick start

Send text messages with Crystal!

```crystal
require "nexmo"

# For production set NEXMO_API_KEY and NEXMO_API_SECRET
# environment variables and create a client like this:
client = Nexmo::Client.new

# Alternatively for testing and quick scripting you can
# specify the API key and secret directly like this:
client = Nexmo::Client.new(api_key: "xxx", api_secret: "xxx")

client.send_sms(from: "Crystal", to: "1234567890", text: "Hello!")
```
