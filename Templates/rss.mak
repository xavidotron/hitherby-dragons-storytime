<rss version="2.0" xmlns:atom="http://www.w3.org/2005/Atom">
<channel>

<%
from email.utils import formatdate
import time
def fmtdate(ep):
  return formatdate(time.mktime(ep['postdate'].timetuple()))
%>
  
  <title>Hitherby Dragons Storytime</title>
  <link>http://hitherby.xavid.us/</link>
  <atom:link href="http://hitherby.xavid.us/rss.xml" rel="self" type="application/rss+xml" />
  <description>
    So Jane goes to the edge of the world, where Santa Ynez touches on
    the chaos. She walks across the bridge to the abandoned tower of
    the gibbelins. Finding that its machinery is in recoverable order,
    she assembles a theater company of gods and humans to answer
    suffering.

    Also they put on shows.
  </description>
  <language>en-us</language>
  <copyright>Jenna Moran</copyright>
  <managingEditor>hitherby@xavid.us (Xavid)</managingEditor>
  <webMaster>hitherby@xavid.us (Xavid)</webMaster>
  <pubDate>${fmtdate(episodes[-1])}</pubDate>
  <lastBuildDate>${fmtdate(episodes[-1])}</lastBuildDate>
  <category>Surreal</category>
  <docs>https://validator.w3.org/feed/docs/rss2.html</docs>
  <image>
    <url>http://hitherby.xavid.us/Images/rss.png</url>
    <title>Hitherby Dragons Storytime</title>
    <link>http://hitherby.xavid.us/</link>
    <width>144</width>
    <height>400</height>
  </image>
  %for ep in episodes:
  <item>
    <title>${ep['name']}</title>
    <guid>http://hitherby.xavid.us/${ep['path']}</guid>
    <description>
      &lt;a href="http://hitherby.xavid.us/${ep['path']}"&gt;&lt;img src="http://hitherby.xavid.us/${ep['path']}square.png" /&gt;&lt;/a&gt;
      %if 'tagline' in ep:
        ${ep['tagline']}
      %else:
        From Hitherby Dragons by Jenna Moran.
      %endif
    </description>
    %if 'tags' in ep:
      %for t in ep['tags']:
      <category>${t}</category>
      %endfor
    %endif
    <pubDate>${fmtdate(ep)}</pubDate>
  </item>
  %endfor
</channel>
</rss>
