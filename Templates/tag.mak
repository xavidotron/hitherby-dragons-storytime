## -*- coding: utf-8 -*-
<%inherit file="../base.mak"/>

<h2>${cap_first(tag['tag'])}</h2>
%if 'image' in tag:
<a href="../../Images/${tag['image']}"><img class="right" src="../../Images/${tag['image']}" /></a>
%endif

<p><b>${cap_first(tag['tag'])}</b>
${tag['desc']}

%for st in subtags:
<p><b>${cap_first(st['tag'])}</b>
${st['desc']}
%endfor
  
<h3>Episodes with ${'/'.join([tag['tag']] + [st['tag'] for st in subtags])}:</h3>
  
<table>
%for ep, specific_tags in episodes:
<tr>
  <th><a href="${prefix}${ep['path']}">${ep['name']}</a></th>
  <td>
    ${ep['type']}
    %if 'date' in ep:
    (${ep['date']})
    %endif
  </td>
  %if specific_tags is not None:
  <td>(${specific_tags})</td>
  %endif
</tr>
%endfor
</table>

<%block name="footer">
Hitherby Dragons, including the description here, by <a href="https://www.patreon.com/JennaMoran">Jenna Moran</a>.
%if 'image' in tag:
"${cap_first(tag['tag'])}" character art by <a href="${tag['imageurl']}">${tag['imagecredit']}</a>
%endif
</%block>
