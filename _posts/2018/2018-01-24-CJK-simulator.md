---
layout: post
title: CJK simulator for American
lang: en
category: accessibility
tags:
- UX
- CJK
excerpt: "[HTML content]"
date: 2018-01-24 08:22:53 +0900
---

## Name

<fieldset class="name">
  <legend>Name</legend>
  <div><label>First letter<input size="1" maxlength="1" /></label></div>
  <div><label>Second letter<input size="1" maxlength="1" /></label></div>
  <div><label>Third letter<input size="1" maxlength="1" /></label></div>
</fieldset>

### Explain

Not every people have name in "Firstname Lastname" format. Sometimes, Family name **is** the first name in many country!


## Address

<fieldset class="address">
  <legend>Address</legend>
  <label>Country
    <select>
      <option>미국</option>
      <option>アメリカ</option>
      <option>US</option>
      <option>USA</option>
      <option>America, United</option>
    </select>
  </label>
  <input placeholder="City" />
  <input placeholder="Gu" />
  <input placeholder="Dong" />
  <input placeholder="Remaining" />
  <input class="zipcode" placeholder="Zip code" pattern="[0-9]{6}" />
  <span></span>
</fieldset>


### Explain

For example, Korean people have to find _Korea, republic of._, _South Korea_, _한국_, _대한민국_ in that small select box.
It means we have to scroll down to **K** section, check there is _Korea, republic of._ or something. 
If not, scroll down to **S** section, find _South Korea_.
If not, Scroll down to bottom and select damn translated _대한민국_ or something.

Not every country have address in _Street_, _City_, _State_, _blabla_ format.
But wait… It really needed to separate these input field? rly??

OK, Most of countries have zip code too. But Don't restrict it to your format. Some country have 6 digit zip code and some other is not. The postman will handle this. Not you.


## Input box

<input class="magic" />
{% raw %}
<script>
  document.querySelector('input.magic')
  .addEventListener('keypress', event => {
    if (event.charCode === 0 || event.altKey || event.ctrlKey) return;
    if (Math.random() < 0.3) {
      event.target.value += '\ufffd';
    }
  });
</script>
{% endraw %}


### Explain

Sometimes, Web developer cast a magic into input boxes. But it's malfunctioning when we try to insert CJK characters. IME doesn't work like you are thinking.


{% raw %}
<style>
  .address input {
    display: block;
  }

  input.zipcode:invalid + span:after {
    content: 'Zipcode must be 6 letters';
    color: red;
  }
</style>
{% endraw %}
