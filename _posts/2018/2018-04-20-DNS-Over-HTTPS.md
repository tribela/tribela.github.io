---
layout: post
title: DNS Over HTTPS (DOH) 적용하기
category: settings
date: 2018-04-20 01:25:27 +0900
tags:
  - Ubuntu
  - DNS Over HTTPS
  - Cloudflare
---

올 해 4월 1일에 클라우드플레어가 1.1.1.1이라는 DNS 서버[^1]를 공개했다. 하필 4월 1일에 4개의 1이 들어간 아이피를 쓴 것도 그렇지만 특이하게 DNS Over HTTPS라는 걸 지원하기에 이게 왜 필요한지 알아보고 적용까지 해 봤다.


## DNS Leak

현재 쓰이고 있는 인터넷 기술은 대부분이 엄청 낡은 기술이고 요즘 상황과는 맞지 않는 것도 꽤나 많이 있다. 대표적으로 ARP는 스푸핑에 취약하고 TCP는 너무 오버헤드가 크다고 HTTP over UDP 같은 것도 만들고 있다. DNS도 마찬가지인데 53번 이외의 포트를 쓰기도 어려운데다가 암호화가 전혀 안 되어 있기 때문에 TLS를 적용하든 말든 네트워크 윗단에서 지켜볼 수 있는 사람 혹은 장비(ISP가 될 수도 있고 사내 보안 담당자 혹은 장비가 될 수도 있고)는 내가 어디에 접속하는 지 훤하게 다 볼 수가 있다. 심지어는 VPN을 적용 해도 DNS는 VPN을 타지 않는 경우가 있는데(UDP 패킷을 못 태운다든가..) 이를 DNS-Leak이라고 부른다.
쉽게 말해서 트위터나 페이스북에 접속 했을 때 TLS, HSTS 같은 기술을 통해 내 계정과 통신 내용이 안전하게 보장 된다고 해도 관리자는 내가 업무 시간에 페이스북을 했다는 사실 하나는 알 수 있다는 것이다.


## DNS Over HTTPS (DOH)

앞에서 말한 이유 때문에 DNS 통신을 암호화 하려는 노력은 엄청나게 많이 있었다. TLS 레이어를 적용 한다든가 하는 방식들인데 결국엔 다 표준이 아니기 때문에 추가적으로 프로그램을 설치해야 하는 데다가 결국 끝단에서는 암호화 되지 않은 DNS 패킷이 나가게 된다.

DOH도 마찬가지로 표준도 아니고 처음 들었을 땐 왜 하필 이런 식으로 만들었어야 하나 궁금했다. 이유는 여러 가지가 있는데

- HTTP(S)는 오버헤드가 너무 크다.
- HTTP(S)도 결국 아이피를 직접 입력하지 않는 한 DNS가 필요할텐데?
- 아이피를 직접 입력한다 치면 TLS 인증서는 대체 어떻게 발급 받지?

첫번째 의문에 대해서는 답을 얻지 못했지만 2, 3번째 의문은 쉽게 결론이 났다. onion 주소에까지 인증서를 발급해 주는 DigiCert가 한 몫 했고[^2] 실제로 https://1.1.1.1/ 페이지를 잘 들어갈 수 있다.

결과적으로는 그냥 DNS 요청 결과를 뱉어내는 HTTP API랑 똑같이 생겨먹었는데 [문서](https://developers.cloudflare.com/1.1.1.1/dns-over-https/json-format/)에 나오듯이 그냥 cURL로 요청하면 JSON으로 응답이 오는 것을 알 수 있다.


## 우분투에서 적용하기

난 우분투를 쓰기 때문에 우분투 기준으로 작성했지만 사실 systemd를 사용하고 커널 버전이 말도 안 되게 오래 되지 않는 이상 다 똑같이 할 수 있다. systemd가 아니라 sysvinit을 쓰고 있다면 아마 알아서 잘 변형해서 쓸 수 있을 것이다.


### 1. cloudflared 설치

```sh
$ wget https://bin.equinox.io/c/VdrWdbjqyF/cloudflared-stable-linux-amd64.deb
$ sudo apt-get install ./cloudflared-stable-linux-amd64.deb
$ cloudflared -v
```

### 2. cloudflared 유저 추가

```sh
$ sudo useradd -s /usr/sbin/nologin -r -M cloudflared
```

### 3. 설정파일 만들기

```bash
# /etc/default/cloudflared
CLOUDFLARED_OPTS=--port 53 --upstream https://1.1.1.1/dns-query
```

5053 포트를 사용하라고 하는 글도 있지만 결국 53번 포트가 아니면 쓰기 힘들기 때문에 그냥 53번 포트로 갔다.

```sh
$ sudo chown cloudflared:cloudflared /etc/default/cloudflared
$ sudo chown cloudflared:cloudflared /usr/local/bin/cloudflared
```

```ini
; /lib/systemd/system/cloudflared.service
[Unit]
Description=cloudflared DNS over HTTPS proxy
After=syslog.target network-online.target

[Service]
Type=simple
User=cloudflared
EnvironmentFile=/etc/default/cloudflared
ExecStart=/usr/local/bin/cloudflared proxy-dns $CLOUDFLARED_OPTS
Restart=on-failure
RestartSec=10
KillMode=process

[Install]
WantedBy=multi-user.target
```

1024 이하의 포트는 `root`유저가 아니면 바인드를 못 하는데 그렇다고 root 권한으로 데몬을 실행 할 필요는 전혀 없다. Capability 설정을 하면 된다.

```sh
setcap 'cap_net_bind_service=+ep' $(which cloudflared)
```

적용하고 시작한다

```sh
$ sudo systemctl enable cloudflared
$ sudo systemctl start cloudflared
$ sudo systemctl status cloudflared
```

적용을 해도 시스템에서 사용하지는 못하는데 기본적으로 systemd-resolv가 DNS 시스템을 대체하고 있어서 그렇다. 꺼주고 설정을 바꿔 주자.

```sh
$ sudo systemctl disable systemd-resolved
$ sudo systemctl stop systemd-resolved
```

```config
# /etc/resolv.conf
nameserver 127.0.0.1
```


### 확인해보기


제대로 설정이 되었나 확인하기 위해 53/udp로 나가는 걸 차단하고 와이어샤크로 잡아 봤다.

```sh
$ sudo ufw enable
$ sudo ufw deny out 53/udp
```

![Wireshark captured DNS packet with DOH]({{ "/imgs/2018-04-20-wireshark.png" | absolute_url }})

로컬에서만 53번 포트를 사용하고 돌고 있는 데몬은 TLS를 적용해서 요청을 하는 걸 확인할 수 있었다.


### 추가적으로 할 일

이 방법은 개인 컴퓨터에만 적용하는 방법이고 다른 기기에 적용하기는 어렵다. 공유기에 OpenWRT 혹은 LEDE를 사용하고 있다면 공유기에다가 올려서 핸드폰이나 다른 기기에서 요청하는 DNS까지 전부 DOH를 이용하게 할 수 있다. 하지만 이것까지 적으면 글이 길어지니 나눠서 나중에 올리겠다.


- - -


[^1]: DNS 자체가 Domain Name Server라서 뒤에 서버라는 말을 붙이면 이상할 지도 모르겠지만 DNS는 Domain Name System이라는 말로 쓰이기도 한다. 서버를 붙였다고 중복 된 의미는 아니다.
[^2]: 페이스북의 히든 서비스 https://facebookcorewwwi.onion 역시 특이하게 인증서가 붙어 있는데 DigiCert가 유일하게 인증서를 발급해 주고 있다.
