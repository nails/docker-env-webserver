# Docker Environment: Webserver

These Dockerfiles build an Apache2 webserver, configured with PHP and various other tools:

- Apache2
    + Mod: PageSpeed
    + Mode: Rewrite
    + Mod: SSL
    + Mod: Headers
    + Mod: Expires
- acme.sh
- PHP (`72`, `73`, `74`, `80`, `81`, `82`, `83`, `84`)
    + Extension: PDO
    + Extension: MySQLi
    + Extension: GD
    + Extension: cURL
    + Extension: Zip
    + Extension: INTL
- Composer
- Node (16)
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
nails/docker-env-webserver:apache-php84
nails/docker-env-webserver:apache-php84-laravel
nails/docker-env-webserver:apache-php84-nails
nails/docker-env-webserver:apache-php84-wordpress

nails/docker-env-webserver:apache-php83
nails/docker-env-webserver:apache-php83-laravel
nails/docker-env-webserver:apache-php83-nails
nails/docker-env-webserver:apache-php83-wordpress

nails/docker-env-webserver:apache-php82
nails/docker-env-webserver:apache-php82-laravel
nails/docker-env-webserver:apache-php82-nails
nails/docker-env-webserver:apache-php82-wordpress

nails/docker-env-webserver:apache-php81
nails/docker-env-webserver:apache-php81-laravel
nails/docker-env-webserver:apache-php81-nails
nails/docker-env-webserver:apache-php81-wordpress

nails/docker-env-webserver:apache-php80
nails/docker-env-webserver:apache-php80-laravel
nails/docker-env-webserver:apache-php80-nails
nails/docker-env-webserver:apache-php80-wordpress

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

Composer scripts are available to make this easier:

```bash
# Compile and push everything, in the correct order
composer compile-all-and-push

# Compile just the specific frameworks
composer compile-base
composer compile-nails
composer compile-laravel
composer compile-wordpress

# Push tags to Docker Hub
composer push
```


### Order is important

Build the base images, and push them, before building the framework images:

```bash
docker build -t nails/docker-env-webserver:apache-php72 ./apache/php72
docker build -t nails/docker-env-webserver:apache-php73 ./apache/php73
docker build -t nails/docker-env-webserver:apache-php74 ./apache/php74
docker build -t nails/docker-env-webserver:apache-php80 ./apache/php80
docker build -t nails/docker-env-webserver:apache-php81 ./apache/php81
docker build -t nails/docker-env-webserver:apache-php82 ./apache/php82
docker build -t nails/docker-env-webserver:apache-php83 ./apache/php83
docker build -t nails/docker-env-webserver:apache-php84 ./apache/php84
docker push nails/docker-env-webserver -a
```

Once base images are pushed, build the framework images:

```bash
# Nails images
docker build -t nails/docker-env-webserver:apache-php72-nails ./apache/php72-nails
docker build -t nails/docker-env-webserver:apache-php73-nails ./apache/php73-nails
docker build -t nails/docker-env-webserver:apache-php74-nails ./apache/php74-nails
docker build -t nails/docker-env-webserver:apache-php80-nails ./apache/php80-nails
docker build -t nails/docker-env-webserver:apache-php81-nails ./apache/php81-nails
docker build -t nails/docker-env-webserver:apache-php82-nails ./apache/php82-nails
docker build -t nails/docker-env-webserver:apache-php83-nails ./apache/php83-nails
docker build -t nails/docker-env-webserver:apache-php84-nails ./apache/php84-nails

# Laravel images
docker build -t nails/docker-env-webserver:apache-php72-laravel ./apache/php72-laravel
docker build -t nails/docker-env-webserver:apache-php73-laravel ./apache/php73-laravel
docker build -t nails/docker-env-webserver:apache-php74-laravel ./apache/php74-laravel
docker build -t nails/docker-env-webserver:apache-php80-laravel ./apache/php80-laravel
docker build -t nails/docker-env-webserver:apache-php81-laravel ./apache/php81-laravel
docker build -t nails/docker-env-webserver:apache-php82-laravel ./apache/php82-laravel
docker build -t nails/docker-env-webserver:apache-php83-laravel ./apache/php83-laravel
docker build -t nails/docker-env-webserver:apache-php84-laravel ./apache/php84-laravel

# WordPress images
docker build -t nails/docker-env-webserver:apache-php72-wordpress ./apache/php72-wordpress
docker build -t nails/docker-env-webserver:apache-php73-wordpress ./apache/php73-wordpress
docker build -t nails/docker-env-webserver:apache-php74-wordpress ./apache/php74-wordpress
docker build -t nails/docker-env-webserver:apache-php80-wordpress ./apache/php80-wordpress
docker build -t nails/docker-env-webserver:apache-php81-wordpress ./apache/php81-wordpress
docker build -t nails/docker-env-webserver:apache-php82-wordpress ./apache/php82-wordpress
docker build -t nails/docker-env-webserver:apache-php83-wordpress ./apache/php83-wordpress
docker build -t nails/docker-env-webserver:apache-php84-wordpress ./apache/php84-wordpress

# Push changes
docker push nails/docker-env-webserver -a
```
