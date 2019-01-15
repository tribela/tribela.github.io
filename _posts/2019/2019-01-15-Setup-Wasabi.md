---
layout: post
title: 마스토돈 오브젝트 스토리지를 Wasabi로 옮기기
category: settings
tags:
- Mastodon
- S3
- sysop
date: 2019-01-15 16:04:57 +0900
---

원래 마스토돈에 사용 할 오브젝트 스토리지를 로컬에서 [Minio](https://minio.io/)를 이용해 돌리고 있었는데 슬슬 용량이 부족해져서 S3 호환 서비스인 [Wasabi](https://wasabi.io/)를 써 보기로 했다. 하지만 이게 그냥 생각대로 되지 않고 삽질을 했기에 또 블로그에 글을 남긴다.
전체적으로는 [angristan의 글](https://angristan.xyz/moving-mastodon-media-files-to-wasabi-object-storage/)을 참고 했지만 안 되는 부분이 있기에 추가적으로 쓴다.


## 버킷의 권한 설정

이건 뭐 요약하자면 원래부터 사람이 쓸 물건은 아니었던 아마존을 능숙하게 쓰던 사람만을 위한 서비스인 것 같다. Minio의 경우엔 권한 설정이 간단했다. 버킷/폴더별로 설정을 열고 특정 키를 가진 사람이나 공개적으로 읽기/쓰기등을 가능하게 할 지 선택하는 지극히 상식적인 UI다. 하지만 와사비는 나를 당황스럽고 화나게 했는데 아래와 같다.

![Wasabi policy editor]({{ "imgs/2019-01-15/wasabi_policy_editor.png" | absolute_url }})

아마존의 IAM 형식이라는 건 나중에 알았지만 이렇게 달랑 에디터만 주면서 어떤 문서를 참고해야 할 지 링크마저 주질 않는다. 그냥 이걸 복붙 하면 퍼블릭으로는 읽기(리스팅 제외)만 된다. (`qdon/*` 부분은 당연히 버킷 네임에 맞게 바꿔야 한다)

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AddPerm",
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::qdon/*"
    }
  ]
}
```


## 유저 생성

IAM 탭에 들어가서 일단 정책을 만들어야 한다. 버킷 이름 같은 걸로 정하고 아래 내용을 복붙한다.

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:ListBucket",
      "Resource": "arn:aws:s3:::qdon"
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:GetObject",
        "s3:DeleteObject"
      ],
      "Resource": "arn:aws:s3:::qdon/*"
    }
  ]
}
```

유저를 생성 할 때 API 비밀키는 한 번만 보여주고 다시는 보여주질 않으니까 잘 적어두고 만든 정책을 적용하자.

애초에 API키 있으면 읽기/쓰기 모두 가능, 퍼블릭은 읽기만 가능하도록 하는 설정을 하는데 왜 저런 저수준의 설정까지 내가 만져야 하는 지 전혀 모르겠다. 내부적으로 저렇게 저장 해도 UI는 저렇게 할 필요 없었잖아?


## 마스토돈 설정

내가 이 부분 때문에 한참을 해맸다. 원래대로라면 아래처럼 설정을 하면 제대로 작동이 되어야 한다.
```sh
S3_ENABLED=true
S3_BUCKET=qdon
S3_HOSTNAME=s3.wasabisys.com
S3_ENDPOINT=https://s3.wasabisys.com
S3_PROTOCOL=https
S3_ALIAS_HOST=bucket.qdon.space
```

이것저것 시도해 보면서 떴던 에러들은 대충 이렇다:
- `us-west-1`? `us-east-1`이겠지... 다시 해봐
- 그런 키 없는데? 제대로 적은 거 맞아?

결과적으로 해결법은 엔드포인트를 `https://s3.us-west-1.wasabisys.com`으로 설정하고 `S3_REGION`은 개무시하고 그냥 `us-east-1`로 적든지 맘대로 한다.

애초에 리전을 왜 정해야 하는지도 모르겠는데 그 괴물 아마존이 사실상의 표준이라 리전이 없어도 굳이 설정을 넣어야 하는 곳이 많으니 답답하긴 해도 그냥 쓴다. 하지만 와사비는 그거랑 별개로 또 설정하기가 지옥이었다.


## 기존 미디어 옮기기

뭐 굳이 자세히 설명 안 하겠다. mc를 쓰든 그 망할 awscli를 쓰든 알아서 하면 되는데 이 순서대로 하는 게 편하다.

1. 버킷 생성
2. 기존 미디어 싱크
3. 서버 설정을 바꿔서 새 스토리지를 향하도록
4. 3번 과정에서 누락 된 파일들만 추가적으로 다시 싱크

이렇게 해야 다운타임이나 이미지가 안 뜨는 시간이 가장 적다.
