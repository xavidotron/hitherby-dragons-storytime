## -*- coding: utf-8 -*-
<html>
<head>
<title>${title}</title>
<link rel="stylesheet" href="${prefix}font-awesome/css/font-awesome.min.css">
<style type="text/css">
@font-face {
  font-family: Amarante;
  src: url(${prefix}amarante/Amarante-Regular.ttf);
}

h1 {
  font-family: Amarante;
  font-size: 3em;
  margin: 2px 10px 7px;
}
h1 a {
  text-decoration: none;
  color: black;
}

body {
  max-width: 1000px;
  margin: auto;
  background: url(${prefix}Images/header.jpg) top no-repeat #26056f;
}

blockquote {
  margin: 1em 150px;
}

table {
  border: 1px solid silver;
  border-collapse: collapse;
}
td,th {
  padding: 5px;
  text-align: left;
  border: 1px solid silver;
}
td.c {
  text-align: center;
  width: 1px;
  white-space: nowrap;
}

.tabs {
  margin: 0 5px;
}
.tabs li {
  display: inline-block;
  border: thin solid black;
  padding: 4px 10px;
  background: lightgrey;
}
.tabs li.current {
  background: white;
  border-bottom: thin solid white;
}
.tabs li a {
  text-decoration: none;
}

.main {
  overflow: auto;
  border: thin solid black;
  margin-top: -1px;
  padding: 1em 2em;
  background: white;
  margin-right: 160px;
}

.sidebar {
  width: 130px;
  float: right;
  border: thin solid black;
  background: lightgrey;
  margin-top: 5px;
  padding: 10px;
  position: relative;
}
.sidebar > a {
  display: block;
  margin-top: 2ex;
}
.sidebar img {
  width: 100%;
  display: block;
}
.sidebar ul {
  padding-left: 30px;
}

.footer {
  margin-top: 10ex;
  font-size: smaller;
}

.right {
  float: right;
  margin-left: 5px;
}
img.right {
  width: 150px;
}
.clear {
  clear: both;
}
</style>
</head>
<body>
<h1><a href="${prefix}">Hitherby Dragons Storytime</a></h1>

<ul class="tabs">
%for tab,href in tablist:
  %if title == tab:
    <li class="current">${tab}</li>
  %else:
    <li><a href="${href}">${tab}</a></li>
  %endif
%endfor
</ul>

<div class="sidebar">
<center><b>Elsewhere</b></center>

<ul>
<li><a href="https://soundcloud.com/hitherby">SoundCloud</a>
<li><a href="https://www.youtube.com/channel/UCQZ3UkIccB-P27K1jJTxKcA">YouTube</a>
<li><a href="https://hitherby-storytime.tumblr.com/">Tumblr</a>
<li><a href="https://twitter.com/HitherbyStorytm">Twitter</a>
<li><a href="https://itunes.apple.com/us/podcast/hitherby-dragons-storytime/id1210240055">iTunes</a>
<li><a href="http://fb.me/HitherbyStorytime">Facebook</a>
<li><a href="http://www.stitcher.com/s?fid=132282&refid=stpr">Stitcher</a>
<li><a href="http://tunein.com/radio/Hitherby-Dragons-Storytime-p964711/">TuneIn</a>
</ul>

<center><b>More Hitherby</b></center>

<a href="http://imago.hitherby.com/">The Original</a>

<a href="http://books.hitherby.com/">Enemies Endure</a>

<a href="https://www.smashwords.com/books/view/256783">
<img src="${prefix}Images/jack-o-lantern.jpg" />
Jack o’Lantern Girl</a>

<a href="http://www.drivethrurpg.com/product/142782/Magical-Bears-in-the-Context-of-Contemporary-Political-Theory">
<img src="${prefix}Images/bears.jpg" />
Magical Bears in the Context of Contemporary Political Theory</a>

<a href="https://www.amazon.com/Unclean-Legacy-Jenna-Katerin-Moran/dp/1503013081/">
<img src="${prefix}Images/legacy.jpg" />
An Unclean Legacy</a>

<a href="http://www.drivethrufiction.com/product/102805/Enemies-Endure-Stomping-the-World-Round">
<img src="${prefix}Images/round.jpg" />
Stomping the World Round</a>

<a href="https://www.amazon.com/Invasion-Jenna-Katerin-Moran/dp/1482730057/">
<img src="${prefix}Images/invasion.jpg" />
Invasion</a>

<a href="http://www.lulu.com/shop/rebecca-borgstrom/hitherby-dragons-primal-chaos/paperback/product-96630.html">
<img src="${prefix}Images/chaos.jpg" />
Primal Chaos</a>

</div>

<div class="main">
${self.body()}

<div class="footer clear">
<%block name="footer">
  Hitherby Dragons by <a href="https://www.patreon.com/JennaMoran">Jenna Moran</a>.
</%block>
</div>

</div>

</body>
</html>
