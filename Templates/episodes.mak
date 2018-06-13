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


%if title == 'Timeline':
<p>A chronological ordering of the Histories, with certain additional contextual
  notes.</p>
%endif

%for vi in xrange(len(volumes)):
<%
  vol = volumes[vi]
  printed_vol = False
%>

<%
lastyear = None
%>

%for ei in xrange(len(vol['episodes'])):
<%
ep = vol['episodes'][ei]
%>
<%
if 'name' in ep and 'soundcloud' not in ep and not full:
    continue
%>
%if not printed_vol:
<h2 id="${vi+1}">${vol['name']}</h2>

%if 'desc' in vol:
<p>${vol['desc']}</p>
%endif

<table>
<%
  printed_vol = True
%>
%endif
%if title == 'Timeline':
  %if ep['date'].year != lastyear:
    <tr><th colspan="4">${ep['date'].year}</th></tr>
    <% lastyear = ep['date'].year %>
  %endif
%endif

<tr>
%if title == 'Timeline':
  %if 'source' in ep:
  <td>
  %else:
  <td colspan="2">
  %endif
  %if ep['date'].monthday:
    ${ep['date'].monthday}: 
  %endif
  ##${repr(ep['date'].key)}
%endif

%if 'name' not in ep:
${ep['desc']}
%if 'source' in ep:
  </td><td class="c">
  <a href="${ep['url']}" title="See ${ep['source']}" aria-label="See ${ep['source']}"><i class="fa fa-book" aria-hidden="true"></i></a>
%endif
</td>
</tr>
<% continue %>
%endif

%if title == 'Timeline':
<b><a href="${prefix}${ep['path']}">${ep['name']}</a></b>: ${ep['timenote']}</td>
%else:
<th>${ei + 1}. <a href="${prefix}${ep['path']}">${ep['name']}</a></th>
%endif
%if title != 'Timeline':
<td>
${ep['type']}
%if 'date' in ep:
(${ep['date']})
%endif
</td>
%endif
</tr>
%if title != 'Timeline' and 'tagline' in ep:
<tr>
<td colspan="4"><small>${ep['tagline']}</small></td>
</tr>
%endif
%endfor
%if printed_vol:
</table>
%endif

%endfor
