# Learning Management System

## ✅ install PHP 7.2

Because Moodle 3.5.7 need PHP 7.2 and remember to also setup `intelephense` to
use this php version

1. **Make sure the `ondrej/php` PPA is added**:

   ```bash
   sudo add-apt-repository ppa:ondrej/php
   sudo apt update
   ```

2. **Install PHP 7.2 and common modules**:

   ```bash
   sudo apt install php7.2 php7.2-cli php7.2-common php7.2-mysql php7.2-xml \
   php7.2-mbstring php7.2-curl php7.2-gd php7.2-intl php7.2-readline php7.2-zip\
   libapache2-mod-php7.2
   ```

3. **Set PHP 7.2 as the default version**:

   ```bash
   sudo update-alternatives --install /usr/bin/php php /usr/bin/php7.2 72
   sudo update-alternatives --config php
   ```

4. **Verify**:

   ```bash
   php -v
   ```

## Setup Editor For Moodle

- LSP: `intelephense` (don't use phpactor, it doesn't work below php8.1)
- DAP: `php-debug-adapter`
- Linter: `phpcs` (combine with `.phpcs.xml` to set the `moodle-extra` coding standard)
- Formatter: `php-cs-fixer` (or plus `blade-formatter` this for `laravel`)

```lua
intelephense = {
   cmd = { 'intelephense', '--stdio' },
   filetypes = { 'php' },
   root_dir = require('lspconfig.util').root_pattern('composer.json', '.git'),
   settings = {
      intelephense = {
         environment = {
            phpVersion = '7.2.0', -- for my company, developing moodle 3.5.7
         },
         files = {
            maxSize = 5000000,
         },
      },
   },
},
```

## Development Environment

### Start this source code to be accessed at `http://localhost` (turn VPN on)

This start our moodle source code using the database configuration in the
`config.php`. If we want local database, please uncomment the `mariadb:`
service in `docker-compose.yml` file.

```bash
docker compose up
```

### `Xdebug` PHP Debugger also installed with the `Dockerfile` setup

This service is not come built-in Moodle image or have its own image. So we
have to manually install `Xdebug` inside Moodle container. We'll need `Xdebug
2.9.x` to work with PHP 7.2

Validate `Xdebug` exists:

```bash
# $ docker exec -it moodle-moodle-1 bash
# root@06fb64c54a84:/var/www/html# php -v
# PHP 7.2.34 (cli) (built: Nov 18 2020 11:11:16) ( NTS )
# Copyright (c) 1997-2018 The PHP Group
# Zend Engine v3.2.0, Copyright (c) 1998-2018 Zend Technologies
#   with Zend OPcache v7.2.34, Copyright (c) 1999-2018, by Zend Technologies
#   with Xdebug v2.9.8, Copyright (c) 2002-2020, by Derick Rethans
```

Now we can listen for `Xdebug` on port `9000` in VSCode

Modify `./.vscode/launch.json` and also install [`Xdebug
helper`](https://chromewebstore.google.com/detail/xdebug-helper/eadndfjplgieldjbigjakmdgkmoaaaoc)
Chrome extension

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Listen for Xdebug (Docker)",
      "type": "php",
      "request": "launch",
      "port": 9000,
      "pathMappings": {
        "/var/www/html": "/home/mhc/work/moodle"
      },
      "log": true,
      "ignore": ["**/vendor/**/*.php"]
    }
  ]
}
```

Remeber to change the line below to match your location

```json
"pathMappings": {
   "/var/www/html": "/home/mhc/work/moodle"
},
```

Check logs of `Xdebug` inside moodle container

```bash
docker exec -it moodle-moodle-1 tail -f /tmp/xdebug.log

# Expected log:
# [Step Debug] I: Connecting to configured address/port: 172.17.0.1:9000.
# [Step Debug] I: Connected to debugging client. :-)
```

Also remember to add this query to the URL for debugger

```txt
?XDEBUG_SESSION_START=VSCODE
```

### Give permission to Moodle to write to `local/` directory on host machine

Because:

- The host directory may be owned by your host user
- While the Apache/PHP inside the container typically runs as `www-data` (UID
  33), and it doesn't have write permission to `local/`

```bash
sudo chown -R 33:33 $MOODLE_DOCKER_WWWROOT/local
sudo chmod -R u+w $MOODLE_DOCKER_WWWROOT/local

# Revert above commands
sudo chown -R $(id -u):$(id -g) $MOODLE_DOCKER_WWWROOT/local
```

This helps when we upload `.zip` file to the site to install local plugins for
example. Or else we have to manually download the `.zip` file, and extract it
to the `local/` directory
