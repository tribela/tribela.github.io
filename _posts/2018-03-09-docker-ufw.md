---
layout: post
title: Docker와 UFW 사용시 충돌 해결
category: settings
tags:
- docker
- ufw
- systemd
date: 2018-03-09 10:03:07 +0900
---

Ubuntu를 서버로 사용하다 보면 UFW를 사용하게 된다. 하지만 UFW는 결국 iptables의 예쁜 포장에 불과하고 Docker는 `-p` 옵션을 사용해서 바인딩을 할 때 iptables를 이용해서 DNAT 룰을 설정한다. 결국 UFW에서 막아 둔 포트였어도 포트가 열려버리게 되는데 바인딩을 로컬호스트로 한 게 아니라면 외부에서 접근이 가능한 문제도 있고 도커 그룹에 있는 모두가 방화벽을 무시할 수 있다는 큰 문제도 있다.

기본적인 해결법은 굉장히 간단한데 `--iptables=false` 옵션을 붙여 데몬을 실행하거나 `/etc/docker/daemon.json`에 `iptables: false` 옵션을 넣어주기만 하면 된다. 그러면 도커는 iptables 룰을 내리지 않고 알아서 잘 라우팅을 해 주게 된다. 하지만 이걸로 다 되는 거였으면 내가 글을 안 썼다.

Docker swarm을 이용해서 서비스를 만들면 이 `--iptables=false` 설정을 무시하고 룰을 내려버린다. 정말 어이가 없는 동작인데 결국 도커 권한을 가진 사람이 방화벽 룰을 우회할 수 있다는 취약점의 해결은 못 했지만 UFW의 뜻을 존중하는 실행법으로 그냥 systemd 유닛을 만드는 길을 택했다.


```systemd
[Unit]
Description=ElasticSearch container
After=docker.service
Requires=docker.service

[Service]
TimeoutStartSec=0
Restart=always
ExecStartPre=-/usr/bin/docker stop %n
ExecStartPre=-/usr/bin/docker rm %n
ExecStartPre=/usr/bin/docker pull docker.elastic.co/elasticsearch/elasticsearch:6.2.2
ExecStart=/usr/bin/docker run --rm --name %n \
          --mount src=elasticsearch,dst=/usr/share/elasticsearch/data \
          --ulimit memlock=262144 \
          -p 9200:9200 \
          -e 'ES_JAVA_OPTS=-Xms512m -Xmx512m' \
          docker.elastic.co/elasticsearch/elasticsearch:6.2.2

[Install]
WantedBy=multi-user.target
```

---

https://www.techrepublic.com/article/how-to-fix-the-docker-and-ufw-security-flaw/
http://container-solutions.com/running-docker-containers-with-systemd/
