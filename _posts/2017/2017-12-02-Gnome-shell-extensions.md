---
layout: post
category: settings
tags:
- gnome-shell
- ubuntu
title: Gnome-shell extensions
date: 2017-12-02 10:52:10 +0900
---

우분투 17.10에 오면서 Unity가 아닌 Gnome-shell이 기본 데스크탑 환경이다.
나는 Unity를 굉장히 좋아하지만 지원을 안 해 준다고 하니 적응을 해야겠다 싶어서 이 참에 그냥 넘어왔다.
하지만 있던 기능이 없어지고 하는 일이 있어서 플러그인[^1]을 여러 개 설치해야 하지만 이걸 매번 기억 하고 다닐 수도 없어서 블로그 포스팅으로 남긴다.

## 준비

웹브라우저 안에서 [그놈셸 사이트](https://extensions.gnome.org)에 들어가서 바로 플러그인을 설치할 수 있도록(심지어 브라우저 플러그인을 설치하는 것보다 더 간편해진다) 그놈셸 확장을 설치한다.

```shell
$ sudo apt install chrome-gnome-shell
```

왜 파폭은 지원 안 하고 크롬만 되냐! 싶었는데 패키지명이 저럴 뿐 파이어폭스에서도 제대로 된다.
설치 후에 [그놈셸 로컬](https://extensions.gnome.org/local/)에 들어가 보면 내가 설치 한 플러그인들도 볼 수 있고 그리스몽키를 설치했을 때와 비슷하게 각 플러그인 페이지에 설치 버튼이 생긴다.

한 가지 의문인 건 계정을 만들어서 로그인을 할 수 있는데 그 흔한 별 찍기 기능이 없다. 내가 좋아하는 플러그인을 일일히 기억하든가 아니면 이렇게 블로그 글을 남겨서 메모를 해 둬야 한다는 게 아쉽다.


## 내가 설치해 둔 플러그인들

- [Clock override](https://extensions.gnome.org/extension/1206/clock-override/)
  그놈셸 상단 중앙에 있는 시계의 포맷을 변경할 수 있다.

- [cpufreq](https://extensions.gnome.org/extension/1082/cpufreq/)
  이전 버전에 있던 indicator-cpufreq처럼 CPU 클럭을 띄워준다. 클릭하면 설정도 바꿀 수 있다.

- [Freon](https://extensions.gnome.org/extension/841/freon/)
  lm-sensors를 이용해서 각종 센서들을 통해 수집한 온도(팬 속도도 가능)를 띄워 준다.

- [K StatusNotifiersItem/AppIndicatorSuppport](https://extensions.gnome.org/extension/615/appindicator-support/)
  우분투의 고질적인 문제인 트레이 아이콘이 안 보이는 문제가 gnome-shell로 오면서 이걸 설치해야 해결 된다.

- [TopIcons Plus](https://extensions.gnome.org/extension/1031/topicons/)[^2]
  이것도 깔아야 rambox, discord 같은 앱들도 제대로 보인다. 대체 뭐가 문제인지 모르겠다.

- [Panel World Clock (lite)](https://extensions.gnome.org/extension/946/panel-world-clock-lite/)
  우분투 유니티에서 나온 지 얼마 되지도 않은 그 세계시각 기능이 gnome-shell로 오면서 플러그인을 설치해야 하게 생겼다.

- [Night Light Slider](https://extensions.gnome.org/extension/1276/night-light-slider/)
  밤이 되면 눈이 편하라고 화면을 약간 누렇게 해 주는 기능이 기본으로 있는데 이건 해가 지기 시작 할 땐 좀 적당하지만 최대로 가면 너무 붉다. 그 값을 조절하는 플러그인.

- [system-monitor](https://extensions.gnome.org/extension/120/system-monitor/)[^3]
  시스템 사용량을 그래프로 그려 주는 애플릿이다. `gir1.2-gtop-2.0`, `gir1.2-networkmanager-1.0`을 추가로 설치해 줘야 한다.

- [Dash to Dock](https://extensions.gnome.org/extension/307/dash-to-dock/)[^4]
  독의 위치를 변경하고 모양이나 동작 등을 변경할 수 있다. 독에 있는 실행 중인 아이콘을 워크스페이스/모니터별로 분리하는 기능도 있다.

- [Activities Configurator](https://extensions.gnome.org/extension/358/activities-configurator/)[^4]
  별로 쓸 일조차 없는 Activities 버튼을 지워버리기 위해 설치했다. 밑에 있는 Pixel saver와 같이 이용하기 좋다.

- [Pixel saver](https://extensions.gnome.org/extension/723/pixel-saver/<Paste>)[^4]
  우분투 유니티에서 맥의 그것처럼 창을 최대화 하면 메뉴와 버튼이 상단바에 붙게 되는 게 있었는데 그것과 비슷한 동작을 한다. 이름 그대로 창의 타이틀바만큼의 픽셀을 아껴준다.


----

[^1]: 정확히는 플러그인이 아니라 확장(extension)이지만 한국이 그런 거 구분하긴 했나.. 그것보다 플러그인이라고 봐도 문제 없는 구조다.
[^2]: Added 2018-01-03 08:34:19 +0900
[^3]: Added 2018-03-07 07:37:54 +0900
[^4]: Added 2018-06-14 19:14:14 +0900
