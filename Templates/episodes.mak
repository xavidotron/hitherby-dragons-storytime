## -*- coding: utf-8 -*-
<%inherit file="../base.mak"/>

<script type="text/javascript" src="https://w.soundcloud.com/player/api.js"></script>

%for vi in xrange(len(volumes)):
<% vol = volumes[vi] %>
<h2>${vol['name']}</h2>

%if 'desc' in vol:
<p>${vol['desc']}</p>
%endif

<%
lastyear = None
epep = [ep for ep in vol['episodes'] if 'soundcloud' in ep]
%>
%if len(epep) > 0:
<iframe id="player${vi}" class="right" width="300" height="300" scrolling="no" frameborder="no" src="https://w.soundcloud.com/player/?url=${epep[0]['soundcloud']}&amp;auto_play=false&amp;hide_related=false&amp;show_comments=true&amp;show_user=true&amp;show_reposts=false&amp;visual=true"></iframe>
%endif

<script type="text/javascript">
w${vi} = SC.Widget("player${vi}");
</script>

<table>
%for ei in xrange(len(vol['episodes'])):
<%
ep = vol['episodes'][ei]
%>
<%
if 'name' in ep and 'soundcloud' not in ep:
    continue
%>
%if title == 'Timeline':
  %if ep['date'].year != lastyear:
    <tr><th colspan="4">${ep['date'].year} CE</th></tr>
    <% lastyear = ep['date'].year %>
  %endif
%endif

<tr>
%if 'soundcloud' in ep:
<td class="c"><a href="#" onclick="w${vi}.load('${ep['soundcloud']}', {auto_play: true, visual: true, show_user: false}); return false" title="Play" aria-label="Play"><i class="fa fa-play" aria-hidden="true"></i></a></td>
%else:
<td></td>
%endif

%if title == 'Timeline':
  %if ep['date'].monthday:
    <td>${ep['date'].monthday}: 
  %else:
    <td>
  %endif
%endif

%if 'name' not in ep:
${ep['desc']}</td>
<td class="c">
%if 'source' in ep:
<a href="${ep['url']}" title="See ${ep['source']}" aria-label="See ${ep['source']}"><i class="fa fa-book" aria-hidden="true"></i></a>
%endif
</td>
</tr>
<% continue %>
%endif

%if title == 'Timeline':
<b>${ep['name']}</b>: ${ep['timenote']}</td>
%else:
<th>${ei + 1}. ${ep['name']}</th>
%endif
<td class="c">
%if 'soundcloud' in ep:
  <a href="${ep['soundcloud']}" title="Listen on SoundCloud" aria-label="Listen on SoundCloud"><i class="fa fa-soundcloud" aria-hidden="true"></i></a>
%endif
%if 'youtube' in ep:
  <a href="${ep['youtube']}" title="Listen on YouTube" aria-label="Listen on YouTube"><i class="fa fa-youtube-play" aria-hidden="true"></i></a>
%endif
%if 'stitcher' in ep:
  <a href="${ep['stitcher']}" title="Listen on Stitcher" aria-label="Listen on Stitcher"><i class="fa fa-podcast" aria-hidden="true"></i></a>
%endif
%if 'itunes' in ep:
  <a href="${ep['itunes']}" title="Listen on iTunes" aria-label="Listen on iTunes"><i class="fa fa-apple" aria-hidden="true"></i></a>
%endif
<a href="${ep['url']}" title="Read original text" aria-label="Read original text"><i class="fa fa-book" aria-hidden="true"></i></a>
</td>
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
</table>

%endfor
