# -*- coding: utf-8 -*-
import re, sys, os, subprocess
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

def render_mako(prefix='../', **kw):
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
                               **kw)
        with open(str(target[0]), 'w') as fil:
            fil.write(rendered.encode('utf-8'))
    return render_mako_impl

TABS = ['episodes',
        'about',
        'timeline',
        'characters',
        'credits']
TITLES = {'characters': 'Characters and Strange Entities'}
    
for makof in Glob('Pages/*.mak'):
    stem = str(makof).rsplit('/', 1)[-1].split('.', 1)[0]
    if stem == 'index':
        htmlf = 'docs/index.html'
    else:
        htmlf = 'docs/' + stem + '/index.html'
    c = Command(htmlf, makof, render_mako())
    Depends(c, 'SConstruct')
    for d in Glob('Templates/*.mak'):
        Depends(c, d)

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
                ' ', '-'))
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
        if ep['type'] == 'History':
            age.append(ep)
    volumes.append(vol)

pwd = os.getcwd()
for vol in volumes:
    for ep in vol['episodes']:
        if 'soundcloud' in ep:
            assert 'art' in ep, ep
            assert ep['art'].startswith(ep['type'].lower() + '-'), ep
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

AddOption('--upload',
          dest='upload',
          type='string',
          nargs=1,
          action='store',
          metavar='EP',
          help='upload episode')

FMT_RE = re.compile(r'</?i>')
LINK_RE = re.compile(r'<a href="([^"]+)">([^<]+)</a>[.]?')

def get_tags(ep):
    tags = ['surreal', 'hitherby dragons', 'hitherby dragons storytime']
    tags.append(ep['type'].lower())
    if 'tags' in ep:
        tags += ep['tags']
    return tags

def get_desc(ep):
    desc = ''
    if 'tagline' in next_upload:
        desc = next_upload['tagline'] + '\n'
    desc += 'From Hitherby Dragons by Jenna Moran.\n'
    desc += next_upload['url'] + '\n\n'
    desc += LINK_RE.sub(r'\2:\n\1', next_upload['seebit'].strip()) + '\n\n'
    desc += LINK_RE.sub(r'\1', next_upload['credits'])
    return desc

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
        if raw_input('Upload %s for episode "%s"? [yN] ' % (
                wav, next_upload['name'])) == 'y':
            with open(os.path.expanduser('~/.soundcloud')) as fil:
                client = soundcloud.Client(**yaml.load(fil))
            print 'Uploading', wav, 'to Soundcloud with', square
            scd = dict(
                title=next_upload['name'],
                sharing='public',
                track_type='spoken',
                genre='Storytelling',
                tag_list=' '.join('"%s"' % t for t in tags),
                release_year='2017',
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
                            tracks = [t['id'] for t in pl[0].tracks]
                            tracks.append(track.id)
                            client.put(playlist.uri, playlist={
                                'tracks': map(lambda id: dict(id=id), tracks)
                            })
                            print "Added to playlist", album
                            break
                    else:
                        print "No playlist found for", album
                except Exception, e:
                    print e
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
elif next_upload and 'credits' in next_upload:
    print
    print '== Next Upload =='
    print
    # This is for email convenience
    print next_upload['name']
    print
    print get_desc(next_upload)
    
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
