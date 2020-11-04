# Docker Environment: Webserver

These Dockerfiles build an Apache2 webserver, configured with PHP and various other tools:

- Apache2
    + Mod: PageSpeed
    + Mode: Rewrite
    + Mod: SSL
    + Mod: Headers
    + Mod: Expires
- Certbot
- PHP (`72`, `73`, or `74`)
    + Extension: PDO
    + Extension: MySQLi
    + Extension: GD
    + Extension: cURL
    + Extension: Zip
    + Extension: INTL
- Composer
- Node
- Yarn
- Xdebug (if `$PHP_XDEBUG` is `1`)
- Blackfire (if `$PHP_BLACKFIRE` is `1`)

Additional Framework tools and project configuration also available when using the `*-<framework>` tags:

- `php<version>-nails`
- `php<version>-laravel`
- `php<version>-wordpress`


## Tags

- `nails/docker-env-webserver:php74`, `nails/docker-env-webserver:latest`
- `nails/docker-env-webserver:php74`

## Building

To compile and publish changes to these containers use the following commands:

```
docker build -t nails/docker-env-webserver:<tag> ./php<version>
docker push nails/docker-env-webserver
```