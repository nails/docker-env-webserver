# Docker Environment: Webserver

These Dockerfiles build an Apache2 webserver, configured with PHP and various other tools:

- Apache2
    + Mod: PageSpeed
    + Mode: Rewrite
    + Mod: SSL
    + Mod: Headers
    + Mod: Expires
- acme.sh
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

```
apache-php<version>-nails
apache-php<version>-laravel
apache-php<version>-wordpress
```



## Tags

```bash
nails/docker-env-webserver:apache-php74
nails/docker-env-webserver:apache-php74-laravel
nails/docker-env-webserver:apache-php74-nails
nails/docker-env-webserver:apache-php74-wordpress

nails/docker-env-webserver:apache-php73
nails/docker-env-webserver:apache-php73-laravel
nails/docker-env-webserver:apache-php73-nails
nails/docker-env-webserver:apache-php73-wordpress

nails/docker-env-webserver:apache-php72
nails/docker-env-webserver:apache-php72-laravel
nails/docker-env-webserver:apache-php72-nails
nails/docker-env-webserver:apache-php72-wordpress
```



## Building

To compile and publish changes to these containers use the following commands:

```bash
docker build -t nails/docker-env-webserver:apache-php<version><framework> ./apache/php<version><framework>
docker push nails/docker-env-webserver -a
```


### Order is important

Build the base images, and push them, before building the framework images:

```bash
docker build -t nails/docker-env-webserver:apache-php72 ./apache/php72
docker build -t nails/docker-env-webserver:apache-php73 ./apache/php73
docker build -t nails/docker-env-webserver:apache-php74 ./apache/php74
docker push nails/docker-env-webserver -a
```

Once base images are pushed, build the base images:

```bash
# Nails images
docker build -t nails/docker-env-webserver:apache-php72-nails ./apache/php72-nails
docker build -t nails/docker-env-webserver:apache-php73-nails ./apache/php73-nails
docker build -t nails/docker-env-webserver:apache-php74-nails ./apache/php74-nails

# Laravel images
docker build -t nails/docker-env-webserver:apache-php72-laravel ./apache/php72-laravel
docker build -t nails/docker-env-webserver:apache-php73-laravel ./apache/php73-laravel
docker build -t nails/docker-env-webserver:apache-php74-laravel ./apache/php74-laravel

# WordPress images
docker build -t nails/docker-env-webserver:apache-php72-wordpress ./apache/php72-wordpress
docker build -t nails/docker-env-webserver:apache-php73-wordpress ./apache/php73-wordpress
docker build -t nails/docker-env-webserver:apache-php74-wordpress ./apache/php74-wordpress

# Push changes
docker push nails/docker-env-webserver -a
```
