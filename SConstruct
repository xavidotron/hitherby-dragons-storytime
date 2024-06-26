# -*- coding: utf-8 -*-
import re, sys, os, subprocess, calendar, datetime
import traceback, urllib.request, urllib.error
import yaml
from mako.template import Template
from mako.lookup import TemplateLookup

# This is dumb.
sys.path.append('/Library/Python/2.7/site-packages/')

# was /Applications/Inkscape.app/Contents/Resources/bin/inkscape
INKSCAPE='/Applications/Inkscape.app/Contents/MacOS/inkscape'

AGEORD = {}
# (age, "first" year in age)
AGEYEAR = [
    ('Unknown', -95000),
    ('Prehistory', -90000),
    ('Second Kingdom', -85000),
    ('Second Tyranny', -80000),
    ('Third Kingdom', -70000),
    ('Third Tyranny', -1211),
    ('Fourth Kingdom', -538),
    ('Fourth Tyranny', 716)
]
for age, year in AGEYEAR:
    AGEORD[age] = year

class dateparse(object):
    def __init__(self, d):
        self.age = None
        yearquest = ''
        extra = ''
        if hasattr(d, 'year'):
            self.monthday = '%s %d' % (calendar.month_name[d.month], d.day)
            self.key = (d.year, d.month, d.day, '')
            self.full = '%s, %s' % (self.monthday, d.year)
            self.year = d.year
        else:
            suffix = ''
            d = str(d)
            if '.' in d:
                d, extra = d.split('.')
                extra = '.' + extra
            while d[-1] in ('?', '+', '-'):
                #extra = d[-1] + extra
                suffix = d[-1] + suffix
                d = d[:-1]
            virtual_month = 0
            virtual_day = 0
            if ':' in d:
                d, virtual = d.split(':')
                if '-' in d:
                    virtual_day = int(virtual)
                else:
                    virtual_month = int(virtual)
            if '-' in d:
                self.year, monthday = d.split('-', 1)
                if '-' in monthday:
                    month, day = monthday.split('-')
                    self.monthday = '%s %s' % (calendar.month_name[int(month)],
                                               int(day))
                else:
                    month = monthday
                    day = virtual_day
                    self.monthday = calendar.month_name[int(month)]
                self.full = '%s, %s%s' % (self.monthday, self.year, suffix)
                self.monthday += suffix
                self.key = (int(self.year), int(month), int(day), extra)
                self.year = int(self.year)
            else:
                self.monthday = None
                self.full = d + suffix
                if ' pesserids before the end of the Second Kingdom' in d:
                    self.year, rest = d.split(' pesserids before the end of the Second Kingdom')
                    self.age = "Second Kingdom"
                    yearquest = suffix
                    self.key = (-70000 - int(self.year),
                                virtual_month, virtual_day, extra)
                    assert rest == '', rest
                    self.year = self.year + ' pesserids before the end of the Second Kingdom'
                elif ' pesserids before time began' in d:
                    self.year, rest = d.split(' pesserids before time began')
                    self.age = "Second Kingdom"
                    yearquest = suffix
                    self.key = (-70000 - int(self.year),
                                virtual_month, virtual_day, extra)
                    assert rest == '', rest
                    self.year = self.year + ' pesserids before time began'
                elif ' BCE' in d:
                    self.year, rest = d.split(' BCE')
                    yearquest = suffix
                    if self.year[-1] == 's':
                        self.year = self.year[:-1]
                        yearquest = 's' + yearquest
                    self.key = (-int(self.year), virtual_month, virtual_day, extra)
                    assert rest == '', rest
                    self.year = -int(self.year)
                elif d in AGEORD:
                    self.key = (AGEORD[d], 0, 0, extra)
                    self.year = ''
                    self.monthday = suffix
                    self.age = d
                elif ' ' in d:
                    self.year, self.monthday = d.split(' ')
                    if self.monthday.isdigit():
                        self.year, self.monthday = self.monthday, self.year
                        self.key = (int(self.year), virtual_month, virtual_day, extra)
                        self.year = int(self.year)
                elif '-' in d:
                    self.year, month = d.split('-')
                    self.monthday = calendar.month_name[int(month)]
                    self.full = '%s, %s%s' % (self.monthday, self.year, suffix)
                    self.key = (int(self.year), int(month), virtual_day, extra)
                    self.year = int(self.year)
                else:
                    yearquest = suffix
                    if d[-1] == 's':
                        d = d[:-1]
                        yearquest = 's' + yearquest
                    self.key = (int(d), virtual_month, virtual_day, extra)
                    self.year = int(d)
        if self.age is None:
            vyear = self.year
            if extra == '.9':
                vyear += 1
            for age, year in AGEYEAR:
                if vyear >= year:
                    self.age = age
            
            if self.year < 0:
                self.year = '%d%s BCE' % (-self.year, yearquest)
            else:
                self.year = '%d%s CE' % (self.year, yearquest)
        
    def __repr__(self):
        return '<%s>' % repr(self.key)
    def __str__(self):
        return self.full
    def __cmp__(self, other):
        return cmp(self.key, other.key)
    def __lt__(self, other):
        return self.key < other.key
                

def get_title(tab):
    return TITLES[tab] if tab in TITLES else tab.title().replace('-', ' ')
def get_href(tab, prefix):
    if tab == 'episodes':
        return prefix
    else:
        return '%s%s/' % (prefix, tab)

def cap_first(s):
  return s[0].upper() + s[1:]

def maybe_space(s):
    if s.startswith(','):
        return s
    else:
        return ' ' + s

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
                               maybe_space=maybe_space,
                               tag_path=tag_path,
                               get_url=get_url,
                               **kw)
        with open(str(target[0]), 'w') as fil:
            fil.write(rendered)
    return render_mako_impl

def name_sanitize(t, escape_colons=True):
    ret = t.replace(u' \u2013 ', '-').replace(u'\u2014 ', '-').replace(u'\u2014', '-').replace(u'\u00B9', '').replace('?', '').replace(' ', '-').replace(u'\u2019', '-').replace(',', '').replace('!', '').replace('(', '').replace(')', '').replace('/', '-').replace('.', '').replace('#', '').replace(u'\u201c', '').replace(u'\u201d', '').replace(u'\u2018', '').replace(u'\u2019', '').lower()
    if escape_colons:
        ret = ret.replace(':', '')
    return ret

OVERRIDE_MAP = {
    'historical-note': 'what-is-hitherby-dragons',
    'one-of-those-days': 'the-river-at-the-edge-of-the-world',
    'the-worlds-not-fair-to-dead-people': 'the-world-s-not-fair-to-dead-people',
    'a-reasonable-explanation': 'creating-reasonable-explanations',
    'dont-forget-your-infinite-mercy-kwan-yin': 'don-t-forget-your-infinite-mercy-kwan-yin',
    'static': 'static-1-of-1',
    'the-dove-ii': 'the-dove',
    'mylittas-question-iiiv': 'mylitta-s-question-ii-iv',
    'devadatta-and-various-killers-iii': 'devadatta-and-various-killers-iii',
    'the-betrothal-v-backfill-to-be': 'the-betrothal-v',
    'the-sifter': 'legend-of-the-sifter',
    'martin-and-lisa-iiii': 'martin-and-lisa-i-iii',
    'good-friday-hitherby-annual-1-ii-tre-ore-2': 'good-friday-hitherby-annual-1-i-i-tre-ore',
    'holy-saturday-stories-of-deliverance': 'holy-saturday-stories-of-deliverance-i-i',
    'merediths-fairy-tale': 'meredith-s-fairy-tale',
    'why-cant-i-fix-you-iii': 'why-can-t-i-fix-you-i-ii',
    'the-birth-of-persephone-iiii': 'the-birth-of-persephone-i-iii',
    'that-was-quick-the-monster-said-iiii': 'that-was-quick-the-monster-said-i-iii',
    'low-saturday-the-harrowing-of-hell-iiv': 'low-saturday-the-harrowing-of-hell-ii-v',
    'easter-that-morning-iiiv': 'easter-that-morning-iii-v',
    'wishing-boy-iiiv-2': 'wishing-boy-ii-iv',
    'nabonidus-gods-iviv': 'nabonidus-gods-iv-iv',
    'the-miracle-iv': 'the-miracle-iv',
    'angus-bad-day': 'angus-bad-day',
    'the-ragged-things-1-of-1': 'the-ragged-things-1-of-2',
    'palm-sunday-iiv-sid-and-max': 'palm-sunday-i-iv-sid-and-max',
    'palm-sunday-iiiv-jigsawing': 'palm-sunday-ii-iv-jigsawing',
    'palm-sunday-iiiiv-mr-mcgruders-question': 'palm-sunday-iii-iv-mr-mcgruder-s-question',
    'palm-sunday-iviv-the-siggort-in-exile': 'palm-sunday-iv-iv-the-siggort-in-exile',
    'she-had-forgotten-all-the-red-complete': 'she-had-forgotten-all-the-red',
    'newtons-first-law-4-of-4': 'newton-s-first-law-4-of-4',
    'hurry-on-2-of-4': 'the-chaos-adapts-2-of-4',
    'severance-4-of-4': 'the-peculiar-case-of-miss-mu-lung-4-of-4',
    'ink-in-re-dyslexic-agnostics-iiii': 'ink-in-re-dyslexic-agnostics-i-iv',
    'ink-indigestible-iiiii': 'ink-indigestible-ii-iv',
    'iviv': 'that-moldless-legacy-of-hell-iv-iv',
    'the-latter-days-of-the-law-2-of-2-2': 'the-latter-days-of-the-law-2-of-2',
    'transience-iiiv': 'transience-ii-v',
    'the-blasphemous-thing-iiv': 'this-blasphemous-thing-i-v',
}
SUF_MAP = {
    '-ii': '-i-i',
    '-iii': '-i-ii', # Could really be III/?
    '-iiii': '-ii-ii', # Could really be I/III
    '-iiiii': '-ii-iii',
    '-iiiiii': '-iii-iii',
    '-iiv': '-i-iv', # Could really be II/V
    '-iiiv': '-ii-iv',
    '-iiiiv': '-iii-iv',
    '-iviv': '-iv-iv',
    '-iv': '-i-v',
    '-ixvi': '-i-xvi',
    '-iixvi': '-ii-xvi',
    '-iixvi': '-ii-xvi',
    '-iiixvi': '-iii-xvi',
    '-ivxvi': '-iv-xvi',
    '-vxvi': '-v-xvi',
    '-vixvi': '-vi-xvi',
    '-viixvi': '-vii-xvi',
    '-viiixvi': '-viii-xvi',
    '-ixxvi': '-ix-xvi',
    '-xxvi': '-x-xvi',
    '-xixvi': '-xi-xvi',
    '-xiixvi': '-xii-xvi',
    '-xiiixvi': '-xiii-xvi',
    '-xivxvi': '-xiv-xvi',
    '-xvxvi': '-xv-xvi',
    '-xvixvi': '-xvi-xvi',
    # These are just for the apostraphe fix, since these aren't in the name.
    '-1-of-1': '-1-of-1',
}
URL_200S = set()
URL_404S = set()

def get_url(ep):
    if ep['url'].startswith('http://hitherby-dragons.wikidot.com'):
        return ep['url']
    _, page, _ = ep['url'].rsplit('/', 2)
    if page in OVERRIDE_MAP:
        page = OVERRIDE_MAP[page]
    elif '-' in page:
        for suf in SUF_MAP:
            if not page.endswith(suf):
                continue
            pref = page[:-len(suf)]
            if u'’' in ep['name'] and u'’ ' not in ep['name']:
                pref = name_sanitize(ep['name'])
            page = pref + SUF_MAP[suf]
            break
        else:
            if u'’' in ep['name'] and u'’ ' not in ep['name']:
                page = name_sanitize(ep['name'])
    assert page != 'hitherby-dragons.wikidot.com', ep
    ret = u'http://hitherby-dragons.wikidot.com/' + page
    return ret

def get_desc(ep):
    desc = ''
    if 'tagline' in ep:
        desc = ep['tagline'] + '\n'
    desc += 'From Hitherby Dragons by Jenna Moran.\n'
    desc += get_url(ep) + '\n\n'
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

AddOption('--bonus',
          dest='bonus',
          action='store_true',
          help='post bonus episode to social media')
bonus = GetOption('bonus')

volumes = []
ages = {}
prev_ep = None
last_upload = None
next_upload = None
upload_vol = None
for yamlf in Glob('Volumes/*.yaml'):
    vol_paths = set()
    with open(str(yamlf)) as fil:
        vol = yaml.load(fil)
    vol['number'] = len(volumes) + 1
    vol['name'] = 'Volume %d: %s' % (len(volumes) + 1, vol['name'])
    for ep in vol['episodes']:
        for t in ep['type'].split(', '):
            assert t in ('Legend', 'Merin', 'History', 'Bonus')
        ep['path'] = '%d/%s/' % (
            vol['number'],
            ep['name'].lower().replace('.', '').replace('?', '').replace(
                ' ', '-').replace(u'’', ''))
        assert ep['path'] not in vol_paths, ep['path']
        vol_paths.add(ep['path'])
        if ep['type'] == 'History':
            assert 'timeline' in ep
        if 'timeline' in ep:
            assert 'History' in ep['type'].split(', ') or ep['legendtime'], ep['type']
            dates = []
            for k in ep['timeline']:
                tl = dict(ep)
                tl['date'] = dateparse(k)
                dates.append(tl['date'])
                tl['timenote'] = ep['timeline'][k]
                ages.setdefault(tl['date'].age, []).append(tl)
            dates.sort()
            ep['date'] = '; '.join(str(k) for k in dates)
        if 'seebit' not in ep and 'seebits' in vol and ep['type'] in vol['seebits']:
            ep['seebit'] = vol['seebits'][ep['type']]
        if 'soundcloud' in ep:
            if prev_ep:
                ep['prev'] = prev_ep['path']
                prev_ep['next'] = ep['path']
            prev_ep = ep
            if not bonus or ep['type'] == 'Bonus':
                last_upload = ep
        else:
            if next_upload is None:
                next_upload = ep
                upload_vol = vol
            if 'credits' in ep:
                print()
                print('== Future Upload ==')
                print()
                # This is for email convenience
                print(ep['name'])
                print()
                print(get_desc(ep))
        url = get_url(ep)
        if url not in URL_200S:
            try:
                urllib.request.urlopen(url)
            except urllib.error.HTTPError:
                print('!!! bad url:', ep['url'], url)
                URL_404S.add(url)
            else:
                URL_200S.add(url)

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
        tags=tags, TAG_TO_EPISODES=TAG_TO_EPISODES, TAG_ALIASES=TAG_ALIASES,
        volumes=volumes))
    Depends(c, 'SConstruct')
    Depends(c, 'tags.yaml')
    for d in Glob('Templates/*.mak'):
        Depends(c, d)

pwd = os.getcwd()
for vol in volumes:
    for ep in vol['episodes']:
        if 'postdate' in ep:
            assert 'art' in ep, ep
            if ep['type'] == 'History': assert 'tagline' in ep, ep
            assert ep['art'].startswith(ep['type'].lower() + '-') or (ep['type'] == 'Bonus' and ep['art'].startswith('legend-')), ep
            for t in ep.get('tags', ()):
                assert t in TAG_TO_EPISODES or t in TAG_ALIASES, t
            for t in list(TAG_TO_EPISODES.keys()) + list(TAG_ALIASES.keys()):
                if t in ep.get('tags', ()) or t in ep.get('notags', ()):
                    continue
                assert t.lower() not in ep['name'].lower(), (t, ep['name'])
                assert t.lower() not in ep.get('tagline', '').lower(), (
                    t, ep['tagline'])
                if 'timeline' in ep:
                    for k in ep['timeline']:
                        timenote = ep['timeline'][k]
                        assert t.lower() not in timenote.lower(), (
                            t, timenote)
                assert t.lower() not in ep['credits'].lower(), (
                    t, ep['credits'])
        if 'soundcloud' in ep:
            c = Command('docs/%sindex.html' % (ep['path']),
                        'Templates/episode.mak', render_mako(
                            volume=vol, episode=ep, prefix='../../',
                            title=ep['name']))
            Depends(c, 'SConstruct')
            Depends(c, 'Templates/base.mak')
            # Simplest to depend on all b/c of prev/next
            for d in Glob('Volumes/*.yaml'):
                Depends(c, d)
        if 'art' in ep:
            c = Command(
                'docs/%ssquare.png' % ep['path'],
                'Art/' + ep['art'],
                INKSCAPE +
                ' -b ffffffff --export-filename=%s/${TARGET} %s/$SOURCE '
                '--export-area=560:0:2000:1440' % (pwd, pwd))
            # This file will change a lot more than the art will.
            #Depends(c, 'Volumes/%02d.yaml' % vol['number'])

            c = Command(
                'docs/%srect.png' % ep['path'],
                'Art/' + ep['art'],
                INKSCAPE +
                ' -b ffffffff --export-filename=%s/${TARGET} %s/$SOURCE '
                '--export-area-page -w 1800 -h 1013' % (pwd, pwd))
            # This file will change a lot more than the art will.
            #Depends(c, 'Volumes/%02d.yaml' % vol['number'])

c = Command('docs/index.html', 'Templates/episodes.mak',
            render_mako(prefix='', volumes=volumes, mode='episodes',
                        title='Episodes',
                        full=False))
Depends(c, 'SConstruct')
Depends(c, 'Templates/base.mak')
Depends(c, 'Volumes/')

with open('historical-notes.yaml') as fil:
    notes = yaml.load(fil)
for n in notes:
    n['date'] = dateparse(n['date'])
    ages[n['date'].age].append(n)

def gk(ep):
    return ep['date'].key
for a in ages:
    ages[a].sort(key=gk)
agelist = [dict(name=k, episodes=ages[k], ord=AGEORD[k]) for k in ages]
agelist.sort(key=lambda a: a['ord'])
    
c = Command('docs/timeline/index.html', 'Templates/episodes.mak',
            render_mako(volumes=agelist,
                        title='Timeline',
                        full=False))
Depends(c, 'SConstruct')
Depends(c, 'Templates/base.mak')
for d in Glob('Volumes/*.yaml'):
    Depends(c, d)
Depends(c, 'historical-notes.yaml')
c = Command('docs/timeline/full.html', 'Templates/episodes.mak',
            render_mako(volumes=agelist,
                        title='Timeline',
                        full=True))
Depends(c, 'SConstruct')
Depends(c, 'Templates/base.mak')
for d in Glob('Volumes/*.yaml'):
    Depends(c, d)
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
        "/usr/local/bin/ffmpeg -loop 1 -y -i 'docs/%srect.png' -i '%s' "
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
        print("Title:", next_upload['name'])
        print("Album:", album)
        print("Description:")
        print(desc)
        print("Tags:", tags)
        print("Post Date:", next_upload['postdate'])
        if raw_input('Upload %s for episode "%s"? [yN] ' % (
                wav, next_upload['name'].encode('utf-8'))) == 'y':
            import soundcloud
            with open(os.path.expanduser('~/.soundcloud')) as fil:
                client = soundcloud.Client(**yaml.load(fil))
            print('Uploading', wav, 'to Soundcloud with', square)
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
            print('Metadata:', scd)
            scd['asset_data'] =open(wav, 'rb')
            scd['artwork_data'] = open(square, 'rb')
            if True:
                try:
                    track = client.post('/tracks', track=scd)
                    # '--artist', 'Hitherby Dragons Storytime',
                    # '--album', album,
                    print("Soundcloud URL:", track.permalink_url)
                    playlists = client.get('/me/playlists')
                    for pl in playlists:
                        if pl.title == album:
                            tracks = [t['id'] for t in pl.tracks]
                            tracks.append(track.id)
                            client.put(pl.uri, playlist={
                                'tracks': map(lambda id: dict(id=id), tracks)
                            })
                            print("Added to playlist", album)
                            break
                    else:
                        print("No playlist found for", album)
                except Exception:
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
if post or bonus:
    def post_stuff(target, source, env):
        desc = '<p><a href="http://hitherby.xavid.us/%s">%s</a>, from <a href="http://hitherby.xavid.us/">Hitherby Dragons Storytime.</a>\n\n' % (
            last_upload['path'], last_upload['name'])
        if 'tagline' in last_upload:
            desc += '<p>' + last_upload['tagline'] + '\n\n'
        desc += '<p><a href="%s">Hitherby Dragons</a> by <a href="http://jennamoran.tumblr.com/">@jennamoran</a>.' % get_url(last_upload)
        print('Description:')
        print(desc)
        if raw_input('Post episode "%s" linking to %s? [yN] ' % (
                last_upload['name'], last_upload['soundcloud'])) == 'y':
            with open(os.path.expanduser('~/.tumblr')) as fil:
                auth = yaml.load(fil)
            import pytumblr
            client = pytumblr.TumblrRestClient(
                auth['consumer_key'], auth['consumer_secret'],
                auth['oauth_token'], auth['oauth_token_secret'])
            # This doesn't seem to do the preview image right...
            print(client.create_audio(
                'hitherby-storytime',
                external_url=last_upload['soundcloud'],
                caption=desc.encode('utf-8'), tags=get_tags(last_upload)))

    Command('post', 'docs/%sindex.html' % last_upload['path'], post_stuff)

def validate_stuff(target, source, env):
    if URL_404S:
        print('!!! Invalid wikidot URLs:', URL_404S)
Command('validate', 'docs/index.html', validate_stuff)
