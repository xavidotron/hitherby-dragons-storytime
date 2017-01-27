## -*- coding: utf-8 -*-
<html>
<head>
<link rel="stylesheet" href="${prefix}font-awesome/css/font-awesome.min.css">
<style type="text/css">
body {
  max-width: 1000px;
  margin: auto;
  padding: 10px;
  background: url(${prefix}Images/header.png) top no-repeat #260565;
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
  margin-bottom: 0;
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
  padding: 10px;
  position: relative;
}
.sidebar img {
  width: 100%;
  display: block;
  margin-top: 2ex;
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
<div><b>More Hitherby</b></div>

<img src="${prefix}Images/jack-o-lantern.jpg" />
<a href="https://www.smashwords.com/books/view/256783">Jack o’Lantern Girl</a>

<img src="${prefix}Images/bears.jpg" />
<a href="http://www.drivethrurpg.com/product/142782/Magical-Bears-in-the-Context-of-Contemporary-Political-Theory">Magical Bears in the Context of Contemporary Political Theory</a>

<img src="${prefix}Images/legacy.jpg" />
<a href="https://www.amazon.com/Unclean-Legacy-Jenna-Katerin-Moran/dp/1503013081/">An Unclean Legacy</a>

<img src="${prefix}Images/round.jpg" />
<a href="http://www.drivethrufiction.com/product/102805/Enemies-Endure-Stomping-the-World-Round">Stomping the World Round</a>

<img src="${prefix}Images/invasion.jpg" />
<a href="https://www.amazon.com/Invasion-Jenna-Katerin-Moran/dp/1482730057/">Invasion</a>

</div>

<div class="main">
${self.body()}
</div>

</body>
</html>
