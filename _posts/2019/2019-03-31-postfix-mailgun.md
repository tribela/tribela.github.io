---
layout: post
title: Postfix를 Mailgun에 연동하기
category: settings
tags:
- postfix
- ubuntu
- email
- mailgun
date: 2019-03-31 19:12:26 +0900
---

Cron은 기본적으로 모든 stdout 출력을 사용자의 로컬 이메일로 전송하도록 되어 있다. MAILTO 설정을 이용해 외부 이메일로 받는 것을 적극 권장하는데 비해 이에 대한 세팅은 꽤나 복잡하다. <abbr title="Full Qualified Domain Name">FQDN</abbr>이 없으면 거부하는 서버들도 많고, 특히 postfix 설정이 복잡한데 이걸 mailgun에 물려서 간단하게 쓰는 방법을 정리한다.
(Mailgun 이외에 Sparkpost 등의 다른 서비스를 써도 되지만 SMTP 전송을 지원해야 한다.)

일단 메일건 가입 정도는 알아서 할 수 있다고 가정하고 대시보드에서 SMTP 인증 정보를 만들어 둬야 한다. 이 글에서는 계정을 `mail@kjwon15.net`, 암호를 `password`라고 가정하겠다.


---

postfix를 설치하고 직접 전송이 아닌 릴레이를 이용하도록 해야 한다.
설치를 하지 않았으면 `sudo apt install postfix`로 설치하고 이미 설치를 했다면 `sudo dpkg-reconfigure postfix` 명령을 통해 설치시 설정화면을 다시 띄운다.

1. 타입을 Satellite system으로 지정한다
2. 시스템 메일 이름은 그냥 둔다
3. SMTP 릴레이 호스트를 `[smtp.mailgun.org]:587`로 설정 한다. `[]`로 둘러 싸면 MX가 아닌 A/AAAA 레코드로 조회하도록 강제한다
4. 나머지 설정은 기본으로 둔다

---

`/etc/postfix/main.cf`를 열고 다음과 같이 추가한다

```config
smtp_sasl_auth_enable = yes
smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd
smtp_sasl_security_options = noanonymous
smtp_sasl_tls_security_options = noanonymous
smtp_sasl_mechanism_filter = AUTH LOGIN
```

`/etc/postfix/sasl_passwd` 파일을 만들고 아래와 같이 적는다. (물론 계정명, 암호, 호스트네임은 알아서 수정해야 한다)

```
smtp.mailgun.org mail@kjwon15.net:password
```

방금 작성한 파일의 권한을 600으로 설정해 다른 유저들이 접근할 수 없게 한다.
`sudo postmap /etc/postfix/sasl_passwd` 명령을 실행하면 `/etc/postfix/sasl_passwd.db` 파일이 생성 된다.

`sudo systemctl restart postfix` 명령을 통해 데몬을 재시작 하고 mail 명령을 이용해 메일을 보내 설정이 제대로 되었는지 테스트 하면 된다.
