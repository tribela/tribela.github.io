---
layout: post
title: systemd user timer로 anacron 대체하기
category: systemd
tags:
- systemd
- cron
- anacron
date: 2022-03-17 21:04:58 +0900
lastmod: 2022-03-17 21:54:49 +0900
---

crontab은 참 편리하다. 매일매일 돌아가는 백업 스크립트 등을 설정하기 좋고 심지어는 설정은 단 한 줄만 적으면 되니까 딱히 까먹을 일도 없다. 그나마 까먹을 수 있는 항목은 돌아갈 시각을 지정하는 부분인데 그건 crontab 파일에 주석으로 적어 놓으면 항상 먼저 보이기 때문에 그 또한 문제도 되지 않는다.

하지만 문제가 있는 것이, 새벽 2시마다 백업을 돌리도록 결정했다면 새벽 2시에 컴퓨터가 항상 켜져 있어야 한다. 매일 낮에만 컴퓨터를 사용하는 경우엔 한 번도 백업이 돌지 않을 수가 있다는 뜻이다. anacron의 경우엔 시스템이 재부팅 했을 경우에 마지막으로 돌았어야 할 작업들을 검사해서 돌지 않았다고 판단이 되면 그 즉시 작업을 돌려버리지만, 문제는 사용자의 crontab에 있는 건 신경을 써 주지 않는다.

방법은 두 가지가 있었다. 어떻게든 사용자 권한으로 anacron을 돌려주는 것과 그냥 systemd를 이용하는 것. 결국 나는 systemd를 사용하기로 결정했다.
단점이 없는 것은 아니다. systemd timer를 이용하면 무조건 service, timer 이렇게 파일을 둘로 쪼개야 하고, systemd의 유닛 파일은 외워서 작성하기 어려울 정도로 보일러템플릿이 좀 크다. winAPI의 winmain을 손으로 적어 본 경험이 있는가? 그와 비슷하다. 결국 어디선가 복사해 오거나 옮겨 적게 된다.

아무튼 블로그에 적어 둬야 또 나중에 찾기 편하다는 서론이었다. 당장 설정파일부터 보자.

```systemd
# ~/.config/systemd/user/backup.service
[Unit]
Description=Backup using restic
After=network.target

[Service]
Type=oneshot
ExecStart=/home/jarm/backup.sh

[Install]
WantedBy=default.target
```

```systemd
# ~/.config/systemd/user/backup.timer
[Unit]
Description=Backup with restic daily
Requires=backup.service

[Timer]
Unit=backup.service
OnCalendar=*-*-* 02:00:00
Persistent=true

[Install]
WantedBy=timers.target
```

요약하면 원샷 스크립트를 서비스로 등록하고 그걸 새벽 2시마다 돌아가게 만드는 타이머를 만들었다. onCalendar 항목은 오히려 crontab보다 더 직관적으로 생겨먹기는 했다. y-m-d h:m:s 형식에 맞춰서 잘 끼워 넣어주면 된다.

`systemd --user daemon-reload` 명령을 이용해서 설정을 다시 불러온 뒤, `systemd --user enable --now backup.timer` 명령으로 타이머를 활성화 할 수 있고 `systemd --user list-timers` 명령을 통해 상태를 확인할 수 있다.

다만 치명적인 문제가 하나 있는데, systemd가 suspend 상태에서 깨어나거나 재부팅을 했을 때 자동으로 이전 작업이 돌았는지 확인을 하기는 하는데 단 한 번이라도 타이머가 정상적으로 돌고 타임스탬프가 찍혔어야 한다고 한다. 솔직히 이 동작은 버그가 아닌가 싶은데, 상식적이라면 타이머를 활성화 하는 순간 타임스탬프를 어딘가에 찍어 두고 그걸 기반으로 판단을 했어야 한다.

systemd timer는 강제실행은 할 수 없지만(서비스를 대신 실행해야 한다), 꼼수로 타임스탬프를 강제로 찍고 다음부터 잘 동작하게 할 수 있다고 한다 [^1][^2]

```sh
mkdir -p ~/.local/share/systemd/timers
touch ~/.local/share/systemd/timers/backup.timer
```

말 안 해도 `backup.timer` 부분은 타이머 이름에 맞게 바꾸어 줘야 한다는 건 당연하다.

[^1]: <https://spwhitton.name/blog/entry/systemdtimerpersistent/>
[^2]: 다만, 재부팅을 하기 전까지는 `systemd --user daemon-reload`를 해도 로그아웃 후 로그인을 해도 마지막 타임스탬프가 인식되진 않는다. 재부팅을 해야만 타임스탬프 파일을 불러와서 인식한다.
