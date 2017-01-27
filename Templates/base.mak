## -*- coding: utf-8 -*-
<html>
<head>
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
.sidebar a {
  display: block;
  margin-top: 2ex;
}
.sidebar img {
  width: 100%;
  display: block;
}
.footer {
  margin-top: 10ex;
  font-size: smaller;
}

.right {
  float: right;
  width: 150px;
}
.clear {
  clear: both;
}
</style>
</head>
<body>
<h1>Hitherby Dragons Storytime</h1>

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

</div>

<div class="main">
${self.body()}

<div class="footer clear">
<%block name="footer">
  Hitherby Dragons by Jenna Moran.
</%block>
</div>

</div>

</body>
</html>
