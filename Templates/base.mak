<html>
<head>
<link rel="stylesheet" href="${prefix}font-awesome/css/font-awesome.min.css">
<style type="text/css">
body {
  max-width: 1000px;
  margin: auto;
  padding: 10px
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
}

.sidebar {
  width: 100px;
  float: right;
  background: lightgrey;
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

<div class="main">
${self.body()}
</div>

<div class="sidebar">
Foo
</div>

</body>
</html>
