# -*- coding: utf-8 -*-
import re, sys, os
import yaml
from mako.template import Template
from mako.lookup import TemplateLookup

class dateparse(object):
    def __init__(self, d):
        if hasattr(d, 'year'):
            self.year = str(d.year)
            self.monthday = '%s %d' % (d.strftime('%B'), d.day)
            self.key = str(d)
            self.full = '%s, %s' % (self.monthday, self.year)
        else:
            d = str(d)
            if '.' in d:
                self.year = d.split('.')[0]
            else:
                self.year = d
            self.monthday = None
            self.key = d
            self.full = self.year
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
        if 'soundcloud' in ep:
            if prev_ep:
                ep['prev'] = prev_ep['path']
                prev_ep['next'] = ep['path']
            prev_ep = ep
        if ep['type'] == 'History':
            age.append(ep)
    volumes.append(vol)

pwd = os.getcwd()
for vol in volumes:
    for ep in vol['episodes']:
        if 'soundcloud' in ep:
            c = Command('docs/%sindex.html' % (ep['path']),
                        'Templates/episode.mak', render_mako(
                            volume=vol, episode=ep, prefix='../../',
                            title=ep['name']))
            Depends(c, 'SConstruct')
            Depends(c, 'Templates/base.mak')
            # Simplest to depend on all b/c of prev/next
            Depends(c, 'Volumes/')

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
            render_mako(prefix='', volumes=volumes, mode='episodes'))
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
