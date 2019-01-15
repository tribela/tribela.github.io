---
layout: post
title: Flake8의 전역 설정하기
category: python
tags:
- flake8
- config
date: 2018-01-02 19:15:35 +0900
---

파이썬으로 프로그램을 작성하다 보면 Ruby나 JS처럼 로컬 환경을 지원하지 않기 때문에 virtualenv나 direnv 등을 사용하게 된다. 그렇기 때문에 lint를 붙일 때 해당 디렉터리는 제외를 시켜 주어야 하지만 virtualenv나 direnv는 로컬에서만 사용하기 때문에 프로젝트 저장소의 린트 설정파일에서는 빠져 있는 경우가 많다.

그렇다고 로컬에서 린트 설정파일을 수정해 놓고 사용하다 보면 실수로 그 설정파일을 같이 커밋 해버리는 실수가 있기 때문에 대부분의 린트 도구들을 개인별 글로벌 설정을 따로 두고 프로젝트 설정파일과 합쳐서 돌아가게 된다. 하지만 Flake8은 전혀 그렇지 않았다.

Flake8의 [문서][flake8 doc]를 읽어 보면 전역 설정을 `~/.config/flake8`에 하라고 되어 있지만 그 동작 방식이 비상식적이다. 전역 설정에서 `exclude=.direnv`를 적어놓고 프로젝트 설정에서 `exclude=tests,docs`를 해 놓았다면 당연히 `.direnv`, `tests`, `docs`가 모두 제외되어야 할 것 같지만 flake8은 가장 마지막 설정파일의 것으로 덮어 씌운다. 즉, 전역설정의 `exclude`는 철저하게 무시 된다. 근데 그렇다고 이전 설정파일을 아예 무시하는 건 아니고 겹치지 않는 설정은 전역 설정의 것을 사용한다[^1].

이건 정말 말도 안 되는 방식이라고 생각했고 해결 방법을 찾아 해맨 지 몇 달이 지난 것 같다. 결국 해결 방법을 찾기는 했다. 바로 `--append-config` 옵션이다. 전역 설정이 로컬 설정에 덮어 씌워지지 않고 머지 되길 원한다면 이것을 사용해야 하는 것이었다. 하지만 당연히 그냥 flake8을 실행하면 안 될 게 뻔하기 때문에 alias를 걸어줬다.
```sh
alias flake8="flake8 --append-config=$HOME/.config/flake8"
```

이제서야 드디어 flake8이 venv, .direnv 등의 디렉터리를 훑지 않고 제대로 돌아가게 만들었다. 솔직히 왜 전역설정을 로컬 설정과 병합하지 않고 덮어 씌우는 지 이해를 할 수가 없다.

---

[^1]: 전역 설정에서 `exclude`, `import-order-style`을 설정하고 프로젝트 설정에서 `exclude`를 설정했다면 프로젝트 설정의 `exclude`와 전역 설정의 `import-order-style`을 사용한다.

[flake8 doc]: http://flake8.pycqa.org/en/latest/user/configuration.html
