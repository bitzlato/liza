# LIZA is accountant reporter for Peatio

[![Build Status](https://travis-ci.org/finfex/liza.svg?branch=master)](https://travis-ci.org/finfex/liza)

Liza is a web server written on Ruby On Rails to monitor financial security of Peatio exchange service.

- [LIZA is accountant reporter for Peatio](#liza-is-accountant-reporter-for-peatio)
  - [Install](#install)
  - [Configure application](#configure-application)
  - [Configure and run for development](#configure-and-run-for-development)
  - [Configure barong](#configure-barong)
  - [Trades](#trades)
  - [Deploy with capistrano](#deploy-with-capistrano)
  - [Build docker image](#build-docker-image)
  - [Setup ENV varilables](#setup-env-varilables)
  - [Contributors](#contributors)
  - [Contributing](#contributing)
  - [License](#license)

## Install

> git clone https://github.com/finfex/liza
> bundle

## Configure application

1. Configure you gateway to map `/liza` route to Liza web-server.
2. Use ENV variables to configure application. Look into `config/database.yml` and `config/settings.yml` to view them.
3. Setup other ENV's:

  * `JWT_PUBLIC_KEY`, for example: export `JWT_PUBLIC_KEY=$(cat ~/peatio/config/secrets/rsa-key.pub| base64 -w0) `
  * `LIZA_CACHE_REDIS_URL` (redis://localhost:6379/2 by default). WARNING: Don't use database
    `1` since it is reserved for barong.
  * `LIZA_SIDEKIQ_REDIS_URL` (redis://localhost:6379/3 by default)
  * `LIZA_HOST`, hostname of service, for example: `dev.bitzlato.bz'
  * `BUGSNAG_API_KEY` bugsnag api key (optional)
  * `REPORTS_DATABASE_NAME`

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

> docker exec -it opendax_barong_1 bundle exec rails runner \
  'Permission.create!([ { role: :superadmin, verb: :all, path: :liza, action: :accept }, \
  { role: :admin, verb: :all, path: :liza, action: :accept }, \
  { role: :accountant, verb: :all, path: :liza, action: :accept }])'

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

## Deploy with capistrano

Initialize directory and configs structure on the server

> bundle exec cap production systemd:puma:setup systemd:sidekiq:setup master_key:setup

## Build docker image

```
docker build -t barong_puma -f config/docker/liza.Dockerfile .
```

## Setup ENV varilables

> bundle exec cap production config:set RAILS_ENV=production LIZA_HOST=<YOUR_HOST>

Deploy application

> bundle exec cap production deploy

## Contributors

* [Danil Pismenny](https://github.com/dapi)

## Contributing

See [CONTRIBUTING](CONTRIBUTING.md).

## License

MIT License, see [LICENSE](LICENSE).
