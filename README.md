# docker-php7

# Getting started

## Installation

```bash
git clone https://github.com/omusico/docker-php7.git
cd docker-php7
docker build --tag $USER/php7 .
```

```
docker run -it --name web-php7 -p 127.0.0.1:8080:80 -v /home/user/php7-test:/opt/webapp myrepo/php7 /bin/bash
```
