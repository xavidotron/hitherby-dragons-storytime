# -*- coding: utf-8 -*-
import re, sys, os, subprocess, calendar
import traceback
import yaml
from mako.template import Template
from mako.lookup import TemplateLookup

# This is dumb.
sys.path.append('/Library/Python/2.7/site-packages/')
import pytumblr
import soundcloud

class dateparse(object):
    def __init__(self, d):
        if hasattr(d, 'year'):
            self.year = str(d.year)
            self.monthday = '%s %d' % (d.strftime('%B'), d.day)
            self.key = str(d)
            self.full = '%s, %s' % (self.monthday, self.year)
        else:
            d = str(d)
            if '-' in d and d.endswith('?'):
                d = str(d)[:-1]
                self.year, month, day = d.split('-')
                self.monthday = '%s %s' % (calendar.month_name[int(month)],
                                           int(day))
                self.key = d
                self.full = '%s, %s?' % (self.monthday, self.year)
                self.monthday += '?'
            else:
                self.monthday = None
                self.key = d
                self.full = d
                if ' ' in d:
                    self.year, self.monthday = d.split(' ')
                    if self.monthday.isdigit():
                        self.year, self.monthday = self.monthday, self.year
                        self.key = '%s %s' % (self.year, self.monthday)
                elif '.' in d:
                    self.year = d.split('.')[0]
                    self.full = self.year
                else:
                    self.year = d
    def __repr__(self):
        return '<%s>' % self.key
    def __str__(self):
        return self.full

def get_title(tab):
    return TITLES[tab] if tab in TITLES else tab.title().replace('-', ' ')
def get_href(tab, prefix):
    if tab == 'episodes':
        return prefix
    else:
        return '%s%s/' % (prefix, tab)

def cap_first(s):
  return s[0].upper() + s[1:]

def render_mako(prefix='../', **kw):
    def tag_path(t):
        if t in TAG_ALIASES:
            return prefix + 'tag/' + TAG_ALIASES[t]
        else:
            return prefix + 'tag/' + t
    def render_mako_impl(target, source, env):
        stem = str(source[0]).rsplit('/', 1)[-1].split('.', 1)[0]
        tmpl = Template(filename=str(source[0]),
                        default_filters=['decode.utf8'],
                        lookup=TemplateLookup(directories=['Templates']))
        tablist = [(get_title(t), get_href(t, prefix)) for t in TABS]
        if 'title' not in kw:
            kw['title'] = get_title(stem)
        rendered = tmpl.render(tablist=tablist,
                               prefix=prefix,
                               cap_first=cap_first,
                               tag_path=tag_path,
                               **kw)
        with open(str(target[0]), 'w') as fil:
            fil.write(rendered.encode('utf-8'))
    return render_mako_impl

def get_desc(ep):
    desc = ''
    if 'tagline' in ep:
        desc = ep['tagline'] + '\n'
    desc += 'From Hitherby Dragons by Jenna Moran.\n'
    desc += ep['url'] + '\n\n'
    desc += LINK_RE.sub(r'\2:\n\1', ep['seebit'].strip()) + '\n\n'
    desc += LINK_RE.sub(r'\1', ep['credits'])
    return desc

FMT_RE = re.compile(r'</?i>')
LINK_RE = re.compile(r'<a href="([^"]+)">([^<]+)</a>[.]?')

TABS = ['episodes',
        'about',
        'timeline',
        'characters',
        'credits']
TITLES = {'characters': 'Characters and Strange Entities'}

with open('tags.yaml') as fil:
    tags = yaml.load(fil)

volumes = []
age = []
prev_ep = None
last_upload = None
next_upload = None
upload_vol = None
for yamlf in Glob('Volumes/*.yaml'):
    with open(str(yamlf)) as fil:
        vol = yaml.load(fil)
    vol['number'] = len(volumes) + 1
    vol['name'] = 'Volume %d: %s' % (len(volumes) + 1, vol['name'])
    for ep in vol['episodes']:
        assert ep['type'] in ('Legend', 'Merin', 'History')
        ep['path'] = '%d/%s/' % (
            vol['number'],
            ep['name'].lower().replace('.', '').replace('?', '').replace(
                ' ', '-').replace(u'’', ''))
        if 'date' in ep:
            ep['date'] = dateparse(ep['date'])
        if 'seebit' not in ep:
            ep['seebit'] = vol['seebits'][ep['type']]
        if 'soundcloud' in ep:
            if prev_ep:
                ep['prev'] = prev_ep['path']
                prev_ep['next'] = ep['path']
            prev_ep = ep
            last_upload = ep
        else:
            if next_upload is None:
                next_upload = ep
                upload_vol = vol
            if 'credits' in ep:
                print
                print '== Future Upload =='
                print
                # This is for email convenience
                print ep['name']
                print
                print get_desc(ep)

        if ep['type'] == 'History':
            age.append(ep)
    volumes.append(vol)

TAG_TO_EPISODES = {}
TAG_ALIASES = {}
DESCRIBED_SUBTAGS = {}
for sec in tags:
    for t in sec['tags']:
        assert t['tag'] not in TAG_TO_EPISODES
        if t['tag'] in TAG_ALIASES:
            DESCRIBED_SUBTAGS[TAG_ALIASES[t['tag']]] = [t]
            continue
        subtags = t.get('subtags', [])
        for st in subtags:
            assert st not in TAG_ALIASES
            TAG_ALIASES[st] = t['tag']
        exp_tags = [t['tag']] + subtags
        TAG_TO_EPISODES[t['tag']] = [
            (ep,
             ', '.join(tg for tg in ep.get('tags') if tg in exp_tags)
             if len(exp_tags) > 1 else None
            )
            for ep in sum((v['episodes'] for v in volumes), [])
            if any([tg in ep.get('tags', ())
                    for tg in exp_tags])
            and 'soundcloud' in ep]

for makof in Glob('Pages/*.mak'):
    stem = str(makof).rsplit('/', 1)[-1].split('.', 1)[0]
    if stem == 'index':
        htmlf = 'docs/index.html'
    else:
        htmlf = 'docs/' + stem + '/index.html'
    c = Command(htmlf, makof, render_mako(
        tags=tags, TAG_TO_EPISODES=TAG_TO_EPISODES, TAG_ALIASES=TAG_ALIASES))
    Depends(c, 'SConstruct')
    Depends(c, 'tags.yaml')
    for d in Glob('Templates/*.mak'):
        Depends(c, d)

pwd = os.getcwd()
for vol in volumes:
    for ep in vol['episodes']:
        if 'soundcloud' in ep:
            assert 'art' in ep, ep
            assert ep['art'].startswith(ep['type'].lower() + '-'), ep
            for t in ep.get('tags', ()):
                assert t in TAG_TO_EPISODES or t in TAG_ALIASES, t
            for t in TAG_TO_EPISODES.keys() + TAG_ALIASES.keys():
                if t in ep.get('tags', ()) or t in ep.get('notags', ()):
                    continue
                assert t.lower() not in ep['name'].lower(), (t, ep['name'])
                assert t.lower() not in ep.get('tagline', '').lower(), (
                    t, ep['tagline'])
                assert t.lower() not in ep.get('timenote', '').lower(), (
                    t, ep['timenote'])
                assert t.lower() not in ep['credits'].lower(), (
                    t, ep['credits'])
            c = Command('docs/%sindex.html' % (ep['path']),
                        'Templates/episode.mak', render_mako(
                            volume=vol, episode=ep, prefix='../../',
                            title=ep['name']))
            Depends(c, 'SConstruct')
            Depends(c, 'Templates/base.mak')
            # Simplest to depend on all b/c of prev/next
            Depends(c, 'Volumes/')
        if 'art' in ep:
            c = Command(
                'docs/%ssquare.png' % ep['path'],
                'Art/' + ep['art'],
                '/Applications/Inkscape.app/Contents/Resources/bin/inkscape '
                '-b ffffffff --export-png=%s/${TARGET} %s/$SOURCE '
                '--export-area=560:0:2000:1440' % (pwd, pwd))
            # This file will change a lot more than the art will.
            #Depends(c, 'Volumes/%02d.yaml' % vol['number'])

            c = Command(
                'docs/%srect.png' % ep['path'],
                'Art/' + ep['art'],
                '/Applications/Inkscape.app/Contents/Resources/bin/inkscape '
                '-b ffffffff --export-png=%s/${TARGET} %s/$SOURCE '
                '--export-area-page --export-dpi=67.5' % (pwd, pwd))
            # This file will change a lot more than the art will.
            #Depends(c, 'Volumes/%02d.yaml' % vol['number'])

c = Command('docs/index.html', 'Templates/episodes.mak',
            render_mako(prefix='', volumes=volumes, mode='episodes',
                        title='Episodes'))
Depends(c, 'SConstruct')
Depends(c, 'Templates/base.mak')
Depends(c, 'Volumes/')

with open('historical-notes.yaml') as fil:
    notes = yaml.load(fil)
for n in notes:
    n['date'] = dateparse(n['date'])
    age.append(n)

def gk(ep):
    return ep['date'].key
age.sort(key=gk)

c = Command('docs/timeline/index.html', 'Templates/episodes.mak',
            render_mako(volumes=[dict(name='The Fourth Tyranny',
                                      episodes=age)],
                        title='Timeline'))
Depends(c, 'SConstruct')
Depends(c, 'Templates/base.mak')
Depends(c, 'Volumes/')
Depends(c, 'historical-notes.yaml')

c = Command('docs/rss.xml', 'Templates/rss.mak',
            render_mako(
                episodes=[
                    ep for ep in
                    sum((v['episodes'] for v in volumes), [])
                    if 'soundcloud' in ep][-15:]))
Depends(c, 'SConstruct')
Depends(c, 'Volumes/')

for sec in tags:
    for t in sec['tags']:
        if t['tag'] in TAG_ALIASES:
            continue
        c = Command('docs/tag/%s/index.html' % t['tag'],
                    'Templates/tag.mak',
                    render_mako(
                        prefix='../../',
                        tag=t,
                        title=cap_first(t['tag']),
                        episodes=TAG_TO_EPISODES[t['tag']],
                        subtags=DESCRIBED_SUBTAGS.get(t['tag'], [])))
        Depends(c, 'SConstruct')
        Depends(c, 'Volumes/')

AddOption('--upload',
          dest='upload',
          type='string',
          nargs=1,
          action='store',
          metavar='EP',
          help='upload episode')

def get_tags(ep):
    tags = ['surreal', 'Hitherby Dragons', 'Hitherby Dragons Storytime']
    tags.append(ep['type'].lower())
    if 'tags' in ep:
        tags += ep['tags']
    return tags

upload = GetOption('upload')
if upload:
    upload = os.path.expanduser(upload)
    Command(
        'vids/%syoutube.mp4' % next_upload['path'],
        [upload, 'docs/%srect.png' % next_upload['path']],
        "/opt/local/bin/ffmpeg -loop 1 -y -i 'docs/%srect.png' -i '%s' "
        "-shortest -acodec libfdk_aac -vcodec libx264 -tune stillimage "
        "'vids/%syoutube.mp4'" % (
            next_upload['path'], upload, next_upload['path']))
    
    def upload_stuff(target, source, env):
        wav = str(source[0])
        square = str(source[1])
        rect = str(source[2])
        vid = str(source[3])
        desc = get_desc(next_upload)
        tags = get_tags(next_upload)
        album = FMT_RE.sub('', upload_vol['name'].strip())
        print "Title:", next_upload['name']
        print "Album:", album
        print "Description:"
        print desc
        print "Tags:", tags
        print "Post Date:", next_upload['postdate']
        if raw_input('Upload %s for episode "%s"? [yN] ' % (
                wav, next_upload['name'].encode('utf-8'))) == 'y':
            with open(os.path.expanduser('~/.soundcloud')) as fil:
                client = soundcloud.Client(**yaml.load(fil))
            print 'Uploading', wav, 'to Soundcloud with', square
            scd = dict(
                title=next_upload['name'],
                sharing='public',
                track_type='spoken',
                genre='Storytelling',
                tag_list=' '.join('"%s"' % t for t in tags),
                release_year=next_upload['postdate'].year,
                release_month=next_upload['postdate'].month,
                release_day=next_upload['postdate'].day,
                description=desc)
            print 'Metadata:', scd
            scd['asset_data'] =open(wav, 'rb')
            scd['artwork_data'] = open(square, 'rb')
            if True:
                try:
                    track = client.post('/tracks', track=scd)
                    # '--artist', 'Hitherby Dragons Storytime',
                    # '--album', album,
                    print "Soundcloud URL:", track.permalink_url
                    playlists = client.get('/me/playlists')
                    for pl in playlists:
                        if pl.title == album:
                            tracks = [t['id'] for t in pl.tracks]
                            tracks.append(track.id)
                            client.put(pl.uri, playlist={
                                'tracks': map(lambda id: dict(id=id), tracks)
                            })
                            print "Added to playlist", album
                            break
                    else:
                        print "No playlist found for", album
                except Exception, e:
                    traceback.print_exc()
            if True:
                subprocess.check_call([
                    'youtube-upload',
                    '--title', next_upload['name'],
                    '--description', desc,
                    '--category', 'Entertainment',
                    '--tags', ', '.join(tags),
                    '--default-language', 'en',
                    '--default-audio-language', 'en',
                    '--playlist', album,
                    vid])
    Command('upload', [
        upload,
        'docs/%ssquare.png' % next_upload['path'],
        'docs/%srect.png' % next_upload['path'],
        'vids/%syoutube.mp4' % next_upload['path'],
    ], upload_stuff)
    
AddOption('--post',
          dest='post',
          action='store_true',
          help='post episode to social media')

post = GetOption('post')
if post:
    def post_stuff(target, source, env):
        desc = ''
        if 'tagline' in last_upload:
            desc += next_upload['tagline'] + '<br />'
        desc += 'From <a href="%s">Hitherby Dragons</a> by <a href="http://jennamoran.tumblr.com/">@jennamoran</a>.' % last_upload['url']
        print 'Description:'
        print desc
        if raw_input('Post episode "%s" linking to %s? [yN] ' % (
                last_upload['name'], last_upload['path'])) == 'y':
            with open(os.path.expanduser('~/.tumblr')) as fil:
                auth = yaml.load(fil)
            client = pytumblr.TumblrRestClient(
                auth['consumer_key'], auth['consumer_secret'],
                auth['oauth_token'], auth['oauth_token_secret'])
            # This doesn't seem to do the preview image right...
            client.create_link(
                'hitherby-storytime', title=last_upload['name'],
                url='http://hitherby.xavid.us/%s' % last_upload['path'],
                description=desc, tags=get_tags(last_upload))

    Command('post', 'docs/%sindex.html' % last_upload['path'], post_stuff)
