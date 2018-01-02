---
layout: post
title: Yahoo weather API
category: API
tags:
  - Yahoo
  - Weather
date: 2017-11-27 06:40:17 +0900
---


날씨 API는 딱히 이거다 싶을 만한 API가 그렇게 많지 않다. 혼자 쓰는 용도로 개발하는 건데 유료 서비스를 쓰기도 좀 그렇고 국가에서 제공하는 API는 인증서부터 똑바로 달지 못 하는 존재들이고[^1] 아무튼 그런 상황이다.
제일 쓸만한 게 Yahoo에서 제공하는 API인데 무료인데다가 구글 등에서 날씨를 검색하면 나오는 결과도 대부분 여기서 가져오는 정보이기 때문에 다른 서비스들과 비슷한 결과를 기대할 수 있다.

하지만 야후 API의 최대 문제는 지역을 코드로 변환한 WOEID를 인자로 주어야 하는데 이게 위도와 경도로 계산하고 그러는 게 아니라 전화번호에 지역번호 붙듯이 누군가가 정해놓은 것이다.
그것 말고도 야후 날씨 API를 이용하는 블로그 글들을 찾아보면 죄다 weather.yahooapis.com을 이용하는데 현재로선 이 주소로 연결 된 서버가 없다. 즉, 사용을 못 한다. 내가 이 글을 쓰는 이유가 그것이다.

결론부터 말하면 새로운 사이트는 [여기][yahoo weather api]다. YQL을 이용해서 날씨를 얻어오게 되어 있는데 기본 예제에 지역명(도시)를 통해 WOEID를 얻어오는 서브쿼리를 이용해 한 번에 날씨를 가져오는 쿼리가 있다. 게다가 API 키를 발급 받으라고 되어 있는데 결과창 밑에 나오는 엔드포인트에 쿼리를 날려보면 키 없이도 잘만 되는 걸 확인 할 수 있었다.

간단한 예제들은 이렇다.

```sql
-- 제주의 날씨를 얻어오기
select * from weather.forecast where woeid in (
    select woeid from geo.places(1) where text = 'Jeju'
    ) and u='c'

-- 제주의 WOEID 얻어오기
select woeid from geo.places(1) where text = 'Jeju'

-- 오늘의 일기예보만 얻어오기
select item.forecast from weather.forecast(1) where woeid = 11495133
```

* `from aaa.ccc(1)`처럼 괄호가 들어가는 것은 `limit 1`의 축약형인 듯 하다. SQL처럼 `limit N`을 써도 똑같이 동작한다.
* 파라미터에 `format=json`을 붙이면 JSON으로 응답을 받을 수 있다[^2]. XML을 굳이 사용 할 이유가 있을까?

간단한 파이썬 코드를 첨부하고 글을 마친다.

```python
from addict import Dict
from pprint import pprint
import requests

url = 'https://query.yahooapis.com/v1/public/yql'

resp = requests.get(
    url,
    headers={
        'Accept': 'application/json',
    },
    params={
        'q': (
            "select item.forecast from weather.forecast where u='c' and woeid in ("
            "select woeid from geo.places(1) where text='Jeju'"
            ") limit 1"),
    })
result = Dict(resp.json())

pprint(result.query.results.channel.item.forecast)
```

[yahoo weather api]: https://developer.yahoo.com/weather/
[^1]: KISA 인증서는 IE를 제외하고 보안적 위협으로 간주, 거부한다
[^2]: 응답 형식은 `Accept` 헤더를 이용해서 지정하는 게 더 RESTful하다. 테스트 결과 이렇게 해도 된다.
