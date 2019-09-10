#
# Wordmove Dockerfile, based on:
# - mfuezesi/wordmove
# - mobingidocker/ubuntu-apache2-php7
# - welaika/wordmove
#

# Pull base image.
FROM ubuntu:16.04

LABEL maintainer="Lai Thanh Trung"

RUN apt-get update
RUN apt-get install -y \
  openssh-server \
  curl \
  rsync \
  mysql-client-5.7 \
  software-properties-common \
  sshpass

RUN \gpg --keyserver hkp://pool.sks-keyservers.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
RUN \curl -sSL https://get.rvm.io | bash -s latest
RUN echo "source /etc/profile.d/rvm.sh" >> /etc/bash.bashrc
RUN /bin/bash -c "source /etc/profile.d/rvm.sh \
  && rvm install ruby --latest \
  && gem install wordmove"
ENV RUBYOPT="-KU -E utf-8:utf-8"
RUN curl -o /usr/local/bin/wp -L https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
  && chmod +x /usr/local/bin/wp

RUN LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php
RUN apt-get update && apt-get install -y --no-install-recommends \
		libapache2-mod-php7.2 \
		php7.2 \
		php7.2-cli \
		php7.2-curl \
		php7.2-mbstring \
		php7.2-mysql \
	&& apt-get clean \
	&& rm -fr /var/lib/apt/lists/*

RUN /bin/bash -l -c "gem install rbnacl-libsodium"
RUN /bin/bash -l -c "gem install rbnacl -v 4.0"
RUN /bin/bash -l -c "gem install bcrypt_pbkdf -v 1.0"

# WP-CLI requires to be executed as non-root, unless --allow-root is given
# As Wordmove currently doesn't call WP-CLI with this flag, the image is executed with a non-root user
RUN useradd wordmove && echo "wordmove:wordmove" | chpasswd && adduser wordmove sudo
RUN mkdir -p /home/wordmove && chown wordmove:wordmove /home/wordmove
USER wordmove
RUN echo "alias sudo='sudo env PATH=\$PATH'" > /home/wordmove/.bashrc \
    && chown wordmove:wordmove /home/wordmove/.bashrc

RUN echo 'eval `ssh-agent -s`' >> ~/.bashrc && \
  echo 'ssh-add' >> ~/.bashrc

WORKDIR /home/wordmove
CMD ["/bin/bash"]