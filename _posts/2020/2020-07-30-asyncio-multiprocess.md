---
layout: post
title: asyncio에서 multiprocessing 사용시 This event loop is already running 문제
category: python
tags:
- python
- asyncio
- multiprocessing
date: 2020-07-30 09:22:30 +0900
---

파이썬에서 asyncio를 사용하던 도중 `multiprocessing.Process`로 새 프로세스를 생성한 후 거기서 또 `asyncio.run`을 사용하면 `RunetimeError: This event loop is already running`이라는 에러가 뜰 때가 있다.
그렇다고 `get_running_eventloop`을 사용해 보면, 돌고 있는 이벤트 루프가 없다고 뜨는 이상한 현상이 있다.

아마도 프로세스가 `fork`를 사용하면서 메모리가 복사 되느라 그런 것 같은데 정확한 원인을 모르겠다. 아무튼간에 해결법은 새로운 루프를 만들어서 등록을 해 주면 된다.

```python
loop = asyncio.new_event_loop()
asyncio.set_event_loop(loop)
```
