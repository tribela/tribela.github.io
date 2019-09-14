---
layout: post
title: Nginx 디폴트 설정에 SSL 추가하기
category: settings
tags:
- nginx
- ssl
- tls
date: 2019-09-14 22:43:14 +0900
---

Nginx에 도메인을 여러 개 연결해 놓으면 사이트별로 설정파일을 만들기 마련이다. 각 도메인은 `server_name kjwon15.net;`과 같이 설정하게 되는데 설정하지 않은 도메인은 default 설정파일에 있는 `server_name _;`을 포함하는 서버 블록이 맡게 된다. 보통은 **Welcome to nginx!**를 보게 되지만 문제는 TLS 서버를 세팅했을 때다.

TLS 서버는 기본적으로 `server_name _;`을 가지는 서버 블록이 설정에 없고 동작도 굉장히 이상한데 만약 _abc.kjwon15.net_​이라는 도메인이 _kjwon15.net_​과 같은 IP로 설정 되어 있지만 nginx 설정파일엔 없다고 가정했을 때 _https://abc.kjwon15.net_​에 접속하면 _kjwon15.net_​의 페이지가 **정상적으로**(보이는 듯이) 잘 뜬다. 의도치 않은 결과다. 정확히는 가장 처음으로 TLS가 설정 된 블럭의 서버 설정을 따라가게 된다.

이걸 해결하려면 `server_name _` 설정을 갖는 서버 블록을 설정에 포함하면 된다. 문제는 `ssl_certificate` 설정이 같이 들어가지 않으면 아예 TLS 연결조차 망가지게 되므로 셀프사이닝 한 인증서를 하나 만들어야 한다. 다음과 같은 명령을 통해 만들 수 있다.

```sh
$ sudo mkdir -p /etc/nginx/ssl
$ sudo openssl req -x509 -nodes -newkey rsa:2048 \
 -keyout /etc/nginx/ssl/nginx.key -out /etc/nginx/ssl/nginx.crt
```

그 후 nginx에 디폴트 서버 설정파일을 아래처럼 만든다.

```nginx
server {
    listen 80 default_server;
    listen [::]:80 default_server;

    server_name _;

    return 403;
}

server {
    listen 443 default ssl http2;
    listen [::]:443 default ssl http2;
    server_name _;

    ssl_certificate /etc/nginx/ssl/nginx.crt;
    ssl_certificate_key /etc/nginx/ssl/nginx.key;

    return 403;
}
```

당연하겠지만 이렇게 하면 설정되지 않은 도메인으로 접속하면 TLS 에러가 뜬다. 하지만 적어도 올바르지 않는 도메인에 설정 된 내용이 뜨는 것보다는 나을것이다. 와일드카드 인증서를 발급 받을 수 있다면 그걸 사용해서 제대로 설정 되지 않은 페이지를 띄울 수도 있다.
