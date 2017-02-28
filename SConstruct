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
        print self.key
    def __repr__(self):
        return '<%s>' % self.key
    def __str__(self):
        return self.full

def get_title(tab):
    return TITLES[tab] if tab in TITLES else tab.title().replace('-', ' ')
def get_href(tab, index):
    if index:
        return tab + '/'
    elif tab == 'episodes':
        return '..'
    else:
        return '../%s/' % tab

def render_mako(index=False, **kw):
    def render_mako_impl(target, source, env):
        stem = str(source[0]).rsplit('/', 1)[-1].split('.', 1)[0]
        tmpl = Template(filename=str(source[0]), default_filters=['decode.utf8'],
                        lookup=TemplateLookup(directories=['Templates']))
        tablist = [(get_title(t), get_href(t, index)) for t in TABS]
        if 'title' not in kw:
            kw['title'] = get_title(stem)
        rendered = tmpl.render(tablist=tablist,
                               prefix='' if index else '../',
                               **kw)
        with open(str(target[0]), 'w') as fil:
            fil.write(rendered.encode('utf-8'))
    return render_mako_impl

TABS = ['episodes',
        'about',
        #'timeline',
        #'characters',
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
for yamlf in Glob('Volumes/*.yaml'):
    with open(str(yamlf)) as fil:
        vol = yaml.load(fil)
    for ep in vol['episodes']:
        assert ep['type'] in ('Legend', 'Merin', 'History')
        if 'date' in ep:
            ep['date'] = dateparse(ep['date'])
        if ep['type'] == 'History':
            age.append(ep)
    vol['name'] = 'Volume %d: %s' % (len(volumes) + 1, vol['name'])
    volumes.append(vol)

c = Command('docs/index.html', 'Templates/episodes.mak',
            render_mako(index=True, volumes=volumes, mode='episodes'))
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
