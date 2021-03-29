# LIZA is accountant reporter for Peatio

Liza is a web server written on Ruby On Rails to monitor financial security of Peatio exchange service.

## Install

> git clone https://github.com/finfex/liza
> bundle

## Configure

1. Use ENV variables to configure application. Look into `config/database.yml` and `config/settings.yml` to view them all.
2. Configure you gateway to map `/liza` route to Liza web-server.

## Run for development

> HTTP_PROTOCOL=http bundle exec rails s -p 3000

Open page http://localhost:3000/liza in browser

## Contributors

* [Danil Pismenny](https://github.com/dapi)

## Contributing

See [CONTRIBUTING](CONTRIBUTING.md).

## License

MIT License, see [LICENSE](LICENSE).
