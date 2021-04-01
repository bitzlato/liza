# LIZA is accountant reporter for Peatio

Liza is a web server written on Ruby On Rails to monitor financial security of Peatio exchange service.

## Install

> git clone https://github.com/finfex/liza
> bundle

## Configure application

1. Configure you gateway to map `/liza` route to Liza web-server.
2. Use ENV variables to configure application. Look into `config/database.yml` and `config/settings.yml` to view them.
3. Setup other ENV's:

  * `LIZA_REDIS_URL` (redis://localhost:6379/2 by default). Don't use database
    #1 since it is reserved for barong.

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



## Contributors

* [Danil Pismenny](https://github.com/dapi)

## Contributing

See [CONTRIBUTING](CONTRIBUTING.md).

## License

MIT License, see [LICENSE](LICENSE).
