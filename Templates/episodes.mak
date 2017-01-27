## -*- coding: utf-8 -*-
<%inherit file="../base.mak"/>

%for vi in xrange(len(volumes)):
<% vol = volumes[vi] %>
<h1>Volume ${vi + 1}: ${vol['name']}</h1>

<table>
%for ei in xrange(len(vol['episodes'])):
<% ep = vol['episodes'][ei] %>
<tr>
<th>${ei + 1}. ${ep['name']}</th>
<td>
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
<a href="${ep['url']}" title="Read original in Hitherby Dragons" aria-label="Read original in Hitherby Dragons"><i class="fa fa-book" aria-hidden="true"></i></a>
</td>
<td>
<a href="..#${ep['type']}">${ep['type']}</a>
%if 'date' in ep:
(${ep['date']})
%endif
</td>
</tr>
%endfor
</table>

%endfor
