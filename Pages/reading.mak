## -*- coding: utf-8 -*-
<%inherit file="../base.mak"/>

<%block name="meta">
<meta property="og:image" content="http://hitherby.xavid.us/Images/square.png" />
<meta property="og:url" content="http://hitherby.xavid.us/" />
<meta property="og:title" content="Hitherby Dragons Storytime" />
<meta name="twitter:card" content="summary" />
<meta name="twitter:site" content="@HitherbyStorytm" />
<meta name="twitter:title" content="Hitherby Dragons Storytime" />
<meta name="twitter:image" content="http://hitherby.xavid.us/Images/square.png" />
<meta property="og:description" content="A Voicecast to Answer Suffering" />
<meta name="twitter:description" content="A Voicecast to Answer Suffering" />
</%block>

<p>Presenting a possible reading order of the Imago.</p>

%for vi in xrange(len(volumes)):
<% vol = volumes[vi] %>
<h2 id="${vi+1}">${vol['name']}</h2>

%if 'desc' in vol:
<p>${vol['desc']}</p>
%endif

<%
lastyear = None
%>

<table>
%for ei in xrange(len(vol['episodes'])):
<%
ep = vol['episodes'][ei]
%>

<tr>
<th>${ei + 1}. <a href="${ep['url']}">${ep['name']}</a></th>
<td>
${ep['type']}
%if 'date' in ep:
(${ep['date']})
%endif
</td>
</tr>
%if 'tagline' in ep:
<tr>
<td colspan="4"><small>${ep['tagline']}</small></td>
</tr>
%endif
%endfor
</table>

%endfor
