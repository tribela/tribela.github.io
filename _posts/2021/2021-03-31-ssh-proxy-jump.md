---
layout: post
title: SSH only for JumpProxy
category: settings
tags:
- ssh
date: 2021-03-31 14:36:24 +0900
---

서버를 관리하다보면 SSH의 접근을 특정 호스트에서만 가능하도록 제한해야 할 경우도 생기고 ProxyJump 기능을 사용해야 할 때도 있다.
ProxyJump 기능은 A호스트에 SSH 접속을 해서 그 터널을 통해 B호스트에 접속을 하는 것인데 당연하게도 A호스트에 접속 권한이 있어야 한다. A호스트에 대해서는 권한을 모두 제거하고 B호스트에 접속하기 위한 경유지로서만 사용 가능하게 하도록 설정하는 방법을 기록으로 남긴다.


## 1. jump 전용 계정 만들기

jump라는 계정을 만들 것이다. ssh 키를 담을 홈 디렉터리는 필요하지만, 다른 건 필요하지 않다. 로그인도 못 하도록 nologin을 셸로 지정한다.
```sh
sudo useradd -mN jump -s /usr/sbin/nologin
```

## 2. SSH 키 등록하기

안타깝게도 패스워드로 로그인하는 경우는 다른 기능 제한을 걸 수 없기 때문에, 그리고 보안상 공용의 패스워드를 사용하는 것은 좋지 않기 때문에 authorized_keys 파일을 이용해서 공개키들을 등록해 준다.

`/home/jump/.ssh/authorized_keys` 파일을 만들어 준 뒤 아래와 같이 채워 넣는다.
```ssh
no-user-rc,no-X11-forwarding ssh-rsa AAAA~~~~~ jarm@hostname
```

`ssh-rsa`부터는 본인의 공개키를 넣으면 된다. `no-user-rc,no-X11-forwarding`이 다른 기능들을 사용하지 못하도록 해준다.

실제로 다른 일을 하도록 실행해보면 에러가 뜬다.

```sh
$ ssh jump@es.qdon.tk uptime
This account is currently not available.
```


## 3. 클라이언트 설정하기

사실 설정을 하지 않고서도 ssh jump@A user@B로 접속하면 된다. 하지만 매번 치기 귀찮으니 `~/.ssh/config` 파일을 수정한다.

```sshconfig
Host B
    ProxuJump jump@A
```

당연히 A, B는 적절한 호스트명으로 바꿔야 한다.
