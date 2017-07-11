# -----------------------------------------------------------------------------
# PHP 5.6 Dockerfile
# -----------------------------------------------------------------------------
From artifactory.cobalt.com/skyships-base-agent
MAINTAINER Naresh B

USER root
RUN mkdir /opt/staging \
    && mkdir /opt/staging/configs
WORKDIR /opt/staging/configs
# -----------------------------------------------------------------------------
# PHP 5.6 repository
# -----------------------------------------------------------------------------
RUN yum clean all && yum makecache fast && yum -y update \
    && yum -y install https://mirror.webtatic.com/yum/el7/webtatic-release.rpm && yum -y update \
    && yum -y install php56w php56w-cli php-56w-common php56w-opcache php56w-mysql php56w-mbstring php56w-xml php56w-gd php56w-pear php56w-intl \
    && yum -y install php-drush-drush postfix tcping which && yum clean all

# Composer
RUN wget http://getcomposer.org/composer.phar \
    && wget https://squizlabs.github.io/PHP_CodeSniffer/phpcs.phar \
    && wget https://squizlabs.github.io/PHP_CodeSniffer/phpcbf.phar \
    && wget http://cs.sensiolabs.org/download/php-cs-fixer-v2.phar \
    && wget http://codeception.com/codecept.phar \
    && wget http://www.phing.info/get/phing-latest.phar
# Make sure to provide execute rights for the downloaded files
RUN chown -R 644 /opt/staging/configs/*.phar

RUN sed -i \
	-e 's~^;date.timezone =$~date.timezone = UTC~g' \
	-e 's~^;user_ini.filename =$~user_ini.filename =~g' \
	/etc/php.ini

VOLUME /usr/local/bin /opt/staging/configs
