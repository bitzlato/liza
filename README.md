# LIZA is accountant reporter for Peatio

[![Build Status](https://travis-ci.org/finfex/liza.svg?branch=master)](https://travis-ci.org/finfex/liza)

Liza is a web server written on Ruby On Rails to monitor financial security of Peatio exchange service.

## Install

> git clone https://github.com/finfex/liza
> bundle

## Configure application

1. Configure you gateway to map `/liza` route to Liza web-server.
2. Use ENV variables to configure application. Look into `config/database.yml` and `config/settings.yml` to view them.
3. Setup other ENV's:

  * `LIZA_CACHE_REDIS_URL` (redis://localhost:6379/2 by default). WARNING: Don't use database
    `1` since it is reserved for barong.
  * `LIZA_SIDEKIQ_REDIS_URL` (redis://localhost:6379/3 by default)
  * `JWT_PUBLIC_KEY`, for example: export `JWT_PUBLIC_KEY=$(cat ~/peatio/config/secrets/rsa-key.pub| base64 -w0) `
  * `LIZA_HOST`, hostname of service, for example: `dev.bitzlato.bz'

## Configure and run for development

Liza waits for JWT token in HTTP headers. That is why you need to user API
gateway.

For development add next linex to `config/gateway/mapping-peatio.yaml` in
peatio repo:

```
---
apiVersion: ambassador/v1
kind: Mapping
name: liza_mapping
host: PEATIO_HOST
use_websocket: true
prefix: /liza
rewrite: /liza
service: LIZA_HOST:LIZA_PORT
```

> HTTP_PROTOCOL=http bundle exec rails s -b LIZA_HOST -p LIZA_PORT

Open page //PEATIO_HOST:3000/liza in browser

## Configure barong

> BARONG_SEEDS_FILE=~/liza/config/barong_extra_seeds.yml bundle exec rails c "require_dependency 'barong/seed'; Barong::Seed.new.seed_permissions"

## Trades

```
> Trade.where(taker_type: 'buy', maker_id: account.member_id, market_id: account.currency.dependent_markets).group(:market_id).sum(:total)
{"ethbtc"=>0.35e-6, "ethmcr"=>0.13705116746e4, "ethusdt"=>0.1901506667e2}

> Trade.where(taker_type: 'sell', maker_id: account.member_id, market_id: account.currency.dependent_markets).group(:market_id).sum(:total)
{"ethbtc"=>0.130648e-2, "ethmcr"=>0.421917636669e4, "ethusdt"=>0.5301857527e2}

> Trade.where(taker_type: 'sell', taker_id: account.member_id, market_id: account.currency.dependent_markets).group(:market_id).sum(:total)
{"ethbtc"=>0.270130648e1, "ethmcr"=>0.407396440347e4, "ethusdt"=>0.5112229979e2}

> Trade.where(taker_type: 'buy', taker_id: account.member_id, market_id: account.currency.dependent_markets).group(:market_id).sum(:total)
{"ethbtc"=>0.35e-6, "ethmcr"=>0.137055684973e4, "ethusdt"=>0.1901544933e2}

```

## Contributors

* [Danil Pismenny](https://github.com/dapi)

## Contributing

See [CONTRIBUTING](CONTRIBUTING.md).

## License

MIT License, see [LICENSE](LICENSE).
