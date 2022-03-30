FROM uselagoon/lagoon-cli:latest as LAGOONCLI
FROM uselagoon/php-7.4-cli-drupal:latest

COPY composer.* /app/
COPY assets /app/assets

COPY --from=LAGOONCLI /lagoon /usr/local/bin/lagoon
RUN DOWNLOAD_PATH=$(curl -sL "https://api.github.com/repos/uselagoon/lagoon-sync/releases/latest" | grep "browser_download_url" | cut -d \" -f 4 | grep linux_386) && wget -O /usr/local/bin/lagoon-sync $DOWNLOAD_PATH && chmod +x /usr/local/bin/lagoon-sync

RUN COMPOSER_MEMORY_LIMIT=-1 composer install --no-dev
COPY . /app
RUN mkdir -p -v -m775 /app/web/sites/default/files
    
# Define where the Drupal Root is located
ENV WEBROOT=web
