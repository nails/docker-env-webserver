# Docker Environment: Webserver

These Dockerfiles build an Apache2 webserver, configured with PHP and various other tools:

- Apache2
    + Mod: PageSpeed
    + Mode: Rewrite
    + Mod: SSL
    + Mod: Headers
    + Mod: Expires
- acme.sh
- PHP (`82`, `83`, `84`, `85`)
    + Extension: PDO
    + Extension: MySQLi
    + Extension: GD
    + Extension: cURL
    + Extension: Zip
    + Extension: INTL
- Composer
- Node (22)
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

Every tag is published for both `linux/amd64` (servers) and `linux/arm64` (Apple Silicon).

```bash
nails/docker-env-webserver:apache-php85
nails/docker-env-webserver:apache-php85-laravel
nails/docker-env-webserver:apache-php85-nails
nails/docker-env-webserver:apache-php85-wordpress
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
```

Each tag also has an `-xdebug` variant, e.g. `apache-php85-nails-xdebug`.



## Building

Images are built with `docker buildx` for `linux/amd64` and `linux/arm64` and pushed to Docker Hub as a single multi-arch tag, so the same tag works on an M-series Mac and on an x86 server. This works from either kind of machine; the non-native architecture is built under emulation and is slower (enable "Use Rosetta for x86_64/amd64 emulation" in Docker Desktop to speed this up on a Mac).

```bash
# Build and push everything, in the correct order
composer compile-all-and-push

# Build and push a single group
composer compile-base
composer compile-nails
composer compile-laravel
composer compile-wordpress
composer compile-base-xdebug
composer compile-nails-xdebug
composer compile-laravel-xdebug
composer compile-wordpress-xdebug
```

The `compile-*` scripts **push as they build** — a multi-arch image can't be held in the classic local image store, so there is no separate push step. `docker push nails/docker-env-webserver -a` must not be used: it pushes whatever single-architecture images are in the local store and overwrites the multi-arch tags.

Each pushed tag is checked with `docker buildx imagetools inspect`, and the build fails if either platform is missing.

`bin/build.sh` does the work and can be called directly (run `composer copy-templates` first, `composer delete-templates` after):

```bash
bin/build.sh php85 php85-nails
```

The first run creates a `docker-container` buildx builder named `nails-multiarch`; your default builder is left unchanged.


### Testing changes locally

To build for your own machine only, without pushing anything, set `LOCAL=1`. Images are loaded into the local image store, and framework images build `FROM` your local base image:

```bash
LOCAL=1 composer compile-base
LOCAL=1 composer compile-nails
```


### Order is important

Framework images (`-nails`, `-laravel`, `-wordpress`) build `FROM` the base image, and `-xdebug` images build `FROM` their non-xdebug counterpart. A multi-arch build pulls the parent from Docker Hub, so the parent must be built and pushed first. `composer compile-all-and-push` does this in the right order.
