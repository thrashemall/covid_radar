## CovidRadar telegram bot

![CovidRadarBot comparison chart](/ART/screenshot.jpg)

[https://t.me/CovidRradarBot](https://t.me/CovidRradarBot) For any wishes or suggestions, please write to [covidradar@yahoo.com](mailto:covidradar@yahoo.com)

## Development

```bash
cp config/database.example.yml config/database.yml
cp .env.example.yml .env.development.yml

rake db:create db:migrate db:seed

# Run telegram API agent
ruby bot.rb

# Run requests handler
rails s -p 3000
```
