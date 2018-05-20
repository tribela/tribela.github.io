---
layout: post
category: settings
tags:
- pyenv
- python
- ubuntu
- ibus
- config
title: ubuntu에서 pyenv 사용시 시스템 앱 문제 해결
date: 2018-05-20 17:38:01 +0900
---


우분투에서 기본적으로 제공하는 파이썬 버전은 python(2)와 python3밖에 없기 때문에 버전을 더 세분화 해서 써야 하는 사람들은 pyenv를 쓰게 되고 python3을 기본으로 쓰기 위해 `pyenv global 3.6.5` 등으로 설정을 해 두게 된다. 하지만 이러면 우분투 기본 프로그램들을 실행조차 할 수 없는 경우들이 있는데 이 문제를 해결하게 되었다.

대표적인 문제사항은 deja-dup 같은 앱은 실행조차 안 되고 ibus-daemon도 문제가 있는데 ibus-anthy 사용 시 파이썬을 쓰는지 히라가나 입력이 전혀 안 되는 문제도 있었다. ibus-daemon은 실행이 정상적으로 되긴 해서 뭐가 문제인지 찾는 데 오래 걸리긴 했다.

일단 원인은 두 가지 정도가 있는데 `gi` 모듈이 없거나 python3로는 실행을 할 수 없는 경우다. 해결 방법은 똑같은데 `pyenv shell system`을 실행해 시스템에 깔린 파이썬 버전을 이용하게 하면 된다. 문제는 매번 이러기도 번거롭고 GUI 셸에서 그냥 실행하려고 하면 매번 실패하는 것이다. 이걸 해결하려고 pyenv의 global은 시스템으로 해 두고 `.zshenv` 등에 `PYENV_VERSION=3.6.5`를 적는 것도 생각해 봤지만 아무리 생각해도 별로였다. 그러다가 문득 떠오른 게 있는데 `.zshenv`랑 비슷하게 GUI 셸에도 환경설정 파일이 있었다는 거다.

결과적으로 `~/.pam_environment`에 `PYENV_VERSION=system`을 넣어주고 다시 로그인 하면 된다. 그러면 셸은 시스템에 깔린 python2.7을 사용하게 되니 모든 게 정상적으로 잘 돌아가고 터미널 셸에선 원하는 버전을 기본으로 사용 할 수 있다.
