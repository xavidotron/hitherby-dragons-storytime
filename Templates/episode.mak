## -*- coding: utf-8 -*-
<%inherit file="../base.mak"/>

<%block name="meta">
<meta property="og:image" content="http://hitherby.xavid.us/${episode['path']}square.png" />
<meta property="og:url" content="http://hitherby.xavid.us/${episode['path']}" />
<meta property="og:title" content="${episode['name']}" />
<meta name="twitter:card" content="summary" />
<meta name="twitter:site" content="@HitherbyStorytm" />
<meta name="twitter:title" content="${episode['name']}" />
<meta name="twitter:image" content="http://hitherby.xavid.us/${episode['path']}square.png" />
%if 'tagline' in episode:
<meta property="og:description" content="${episode['tagline']}" />
<meta name="twitter:description" content="${episode['tagline']}" />
%else:
<meta property="og:description" content="From Hitherby Dragons by Jenna Moran." />
<meta name="twitter:description" content="From Hitherby Dragons by Jenna Moran." />
%endif
</%block>

<script type="text/javascript" src="https://w.soundcloud.com/player/api.js"></script>

<iframe id="player" width="450" height="450" scrolling="no" frameborder="no" src="https://w.soundcloud.com/player/?url=${episode['soundcloud']}&amp;auto_play=false&amp;hide_related=false&amp;show_comments=true&amp;show_user=false&amp;show_reposts=false&amp;visual=true&amp;sharing=false"></iframe>

<script type="text/javascript">
w = SC.Widget("player");
</script>

%if 'prev' in episode:
<a href="${prefix}${episode['prev']}">« Previous</a>
%if 'next' in episode:
|
%endif
%endif
%if 'next' in episode:
<a href="${prefix}${episode['next']}">Next »</a>
%endif

<h2>${episode['name']}</h2>

%if 'tagline' in episode:
<p>${episode['tagline']}</p>
%endif

<p>From <a href="${get_url(episode)}">Hitherby Dragons</a> by <a href="https://www.patreon.com/JennaMoran">Jenna Moran</a>.</p>

<p>${episode['seebit']}</p>

<p>${episode['credits'].replace('\n\n', '<p>').replace('\n', '<br>')}

<h3>A ${episode['type']} from <a href="${prefix}#${volume['number']}">${volume['name']}</a></h3>

%if 'tags' in episode:
<p><b>Tags:</b>
%for t in episode['tags']:
  <a href="${tag_path(t)}">${t}</a>
%endfor
%endif

<ul>
<li><a href="${episode['soundcloud']}">Listen on SoundCloud</a>
<li><a href="${episode['youtube']}">Listen on YouTube</a>
<li><a href="${get_url(episode)}">Read original text</a>
</ul>
