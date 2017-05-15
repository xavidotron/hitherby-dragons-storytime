## -*- coding: utf-8 -*-
<%inherit file="../base.mak"/>

<a href="../Images/jane.png"><img class="right" src="../Images/jane.png" /></a>

%for sec in tags:

<h2>${sec['section']}</h2>

%if sec.get('mode') == 'ul':
<ul>
%endif

%for t in sec['tags']:

%if sec.get('mode') == 'ul':
<li>
%else:
<p>  
%endif

%if t['tag'] in TAG_ALIASES or len(TAG_TO_EPISODES[t['tag']]) > 0:
<a href="${tag_path(t['tag'])}/"><b>${cap_first(t['tag'])}</b></a>
%else:
<b>${cap_first(t['tag'])}</b>
%endif
${t['desc']}

%if sec.get('mode') == 'ul':
</li>
%else:
</p>  
%endif

%endfor

%if sec.get('mode') == 'ul':
</ul>
%endif
  
%endfor

<%block name="footer">
  Hitherby Dragons, including the descriptions here, by <a href="https://www.patreon.com/JennaMoran">Jenna Moran</a>.
  "Jane" character art by <a href="http://mamancochet.tumblr.com/">cochet v.</a>
</%block>
