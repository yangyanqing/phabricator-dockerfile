FROM ubuntu:14.04

MAINTAINER Yang Yanqing <yangyanqing.cn@gmail.com>

ENV TZ          Asia/Shanghai
ENV TERM        xterm

RUN locale-gen  zh_CN.UTF-8
ENV LANG        zh_CN.UTF-8
ENV LANGUAGE    zh_CN:zh
ENV LC_ALL      zh_CN.UTF-8

ADD etc/apt/sources.list /etc/apt/

RUN apt-get -qq update && \
    apt-get install -y \
            vim net-tools git git-core subversion apache2 dpkg-dev python-pygments \
            php5 php5-mysql php5-gd php5-dev php5-curl php-apc php5-cli php5-json
RUN a2enmod rewrite

RUN echo "mysql-server mysql-server/root_password password phabricator" | debconf-set-selections
RUN echo "mysql-server mysql-server/root_password_again password phabricator" | debconf-set-selections
RUN apt-get install -y mysql-server

# 清理缓存
RUN apt-get clean -y

# 下载到本地的 Phabricator 代码
# ADD phabricator.tar.gz /opt

# 在网上实时下载代码
WORKDIR /opt
RUN git clone https://github.com/phacility/arcanist.git
RUN git clone https://github.com/phacility/libphutil.git
RUN git clone https://github.com/phacility/phabricator.git

WORKDIR /opt/phabricator
RUN bin/config set mysql.pass "phabricator"
RUN bin/config set mysql.host "localhost"
RUN bin/config set pygments.enabled "true"
RUN bin/config set phabricator.timezone "Asia/Shanghai"
RUN bin/config set metamta.mail-adapter "PhabricatorMailImplementationPHPMailerAdapter"
RUN bin/config set repository.default-local-path "/repos"
RUN bin/config set storage.mysql-engine.max-size "1000000"

# MySQL config
ADD etc/mysql/my.cnf /etc/mysql/

# apache2 config
ADD etc/apache2/sites-enabled/000-default.conf /etc/apache2/sites-enabled/

# php5 config
WORKDIR /etc/php5/apache2
RUN sed -i "s|^;opcache\.validate_timestamps.*|opcache\.validate_timestamps=0|g" php.ini
RUN sed -i "s|^;opcache\.revalidate_freq.*|opcache.revalidate_freq=0|g" php.ini
RUN sed -i "s|\(post_max_size\).*|\1 = 33554432|g" php.ini

# 备份默认生成的文件，供挂载卷使用
RUN mkdir /default-data
RUN cp -r /var/lib/mysql                /default-data/mysql-data
RUN cp -r /etc/mysql                    /default-data/mysql-config
RUN cp -r /opt/phabricator/conf/local   /default-data/phabricator-conf-local

WORKDIR /opt/phabricator

ADD start.sh /

VOLUME ["/etc/mysql", "/var/lib/mysql"] 

EXPOSE 80

ENTRYPOINT ["/start.sh"]

