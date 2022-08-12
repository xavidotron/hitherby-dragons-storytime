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

%for vi in range(len(volumes)):
<% vol = volumes[vi] %>
<h2 id="${vi+1}">${vol['name']}</h2>

%if 'desc' in vol:
<p>${vol['desc']}</p>
%endif

<%
lastyear = None
%>

<table>
%for ei in range(len(vol['episodes'])):
<%
ep = vol['episodes'][ei]
%>

%if 'type' in ep and ep['type'] == 'Bonus':
</table><h3>Holiday Bonus</h3><table>
%endif

<tr>
  <th>
    %if ep.get('type') != 'Bonus':
    ${ei + 1}.
    %endif
    <a href="${get_url(ep)}">${ep['name']}</a></th>
%if ep.get('type') != 'Bonus':
  <td>
    ${ep['type']}
%if 'date' in ep:
(${ep['date']})
%endif
</td>
%endif
</tr>
%if 'tagline' in ep:
<tr>
<td colspan="4"><small>${ep['tagline']}</small></td>
</tr>
%endif
%endfor
</table>

%endfor
