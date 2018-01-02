---
layout: post
title: Select diff from average on SQL
category: SQL
tags:
- sub query
- aggregate
date: 2017-11-21 14:00:06 +0900
---

SQL에서 집계 함수들(`avg`, `sum` 등)은 굉장히 유용하지만 가끔은 답답할 때가 있다. 집계함수를 쓰는 순간 열(row)들이 묶여서 통합되어 나타날 수밖에 없는데 그렇게 하고 싶지 않을 때가 그렇다. 예를 들면 실험 결과를 DB에 저장했는데 평균에서 멀리 떨어진 잘못 측정 된 값만 지우고 다시 하고 싶다든지 하는 경우다.

일단 내가 가진 DB의 스키마는 아래와 같다. 단순하게 실험 결과를 담을 것이기 때문에 sqlite3를 이용했다.

```sql
create table if not exists results(
drawtype, browser, vendor, amount, idle, api, total
);
```

_drawtype_, _browser_, _vendor_, _amount_ 4개가 변인이고 나머지 3개가 측정 결과다. 난 이 중 *total*이 그룹 내(변인이 같은) 평균에서 일정치 이상 떨어진 열을 찾아 삭제하고 싶었다. 단순하게 평균만 뽑자면 아래처럼 할 수 있다.

```sql
select drawtype, browser, vendor, amount, avg(total)
    from results
    group by drawtype, browser, vendor, amount;
```

하지만 이걸 가지고는 평균에서 크게 떨어진 아이들을 찾을 수가 없다. `total - avg(total)` 같은 문법이 된다면 좋겠지만 아쉽게도 그런 건 안 된다. group by를 두 번 따로따로 쓰고 싶은 것이다.
이런 경우, 서브쿼리를 쓰면 간단하게 해결이 된다. 아주 간단히는 아니고 alias를 지정해야만 가능하다(같은 테이블에서 서브쿼리를 내리는데 where절에서 사용해야 하므로).

```sql
select drawtype, browser, vendor, amount, abs(total - (
    select avg(total)
    from results
    where drawtype = t1.drawtype and browser = t1.browser and vendor = t1.vendor and amount = t1.amount
    )) as diff
from results as t1
where diff > 100;
```

서브쿼리 안에서 조건을 지정해서 해당 변인 그룹의 평균을 각각 뽑아내고 그걸 다시 메인 쿼리에서 사용하는 모습이다. 이제 잘못 측정 된 값을 뽑았으니 지우고 다시 실험을 하면 된다. SQL의 편리한 점은 쿼리에서 `select ~~~ from` 부분을 `delete from`으로 바꾸기만 하면 그게 된다는 것인데 여기서는 그걸 하지 못한다. alias를 지정할 수 없기 때문이다.
하지만 그래도 우리에게 방법은 있다. 쿼리를 아주 살짝만 수정해서 삭제를 할 수 있는데 서브쿼리를 또 쓰면 된다.

```sql
delete from results
where rowid in (
    select rowid
    from results as t1
    where abs(total - (
        select avg(total)
        from results
        where drawtype = t1.drawtype and browser = t1.browser and vendor = t1.vendor and amount = t1.amount
    )) > 100)
```

전체를 서브쿼리로 묶고 자잘한 컬럼 대신 rowid를 뽑았다. 중요한 평균값은 alias를 쓰지 않고 where문으로 옮기는 건 불가피했다. 이제 뽑은 rowid를 where절에 넣고 다 날려버리면 깔끔하게 삭제가 된다.
