# -*- coding: utf-8 -*-
import re, sys, os
import yaml
from mako.template import Template
from mako.lookup import TemplateLookup

def get_title(tab):
    return TITLES[tab] if tab in TITLES else tab.capitalize()
def get_href(tab, stem):
    if stem == 'index':
        return tab + '/'
    elif tab == 'index':
        return '..'
    else:
        return '../%s/' % tab

def render_mako(**kw):
    def render_mako_impl(target, source, env):
        stem = str(source[0]).rsplit('/', 1)[-1].split('.', 1)[0]
        tmpl = Template(filename=str(source[0]), default_filters=['decode.utf8'],
                        lookup=TemplateLookup(directories=['Templates']))
        tablist = [(get_title(t), get_href(t, stem)) for t in TABS]
        rendered = tmpl.render(tablist=tablist,
                               title=get_title(stem),
                               prefix='' if stem == 'index' else '../',
                               **kw)
        with open(str(target[0]), 'w') as fil:
            fil.write(rendered.encode('utf-8'))
    return render_mako_impl

TABS = ['index', 'episodes', 'characters', 'credits']
TITLES = {'index': 'About'}
    
for makof in Glob('Pages/*.mak'):
    stem = str(makof).rsplit('/', 1)[-1].split('.', 1)[0]
    if stem == 'index':
        htmlf = 'gh-pages/index.html'
    else:
        htmlf = 'gh-pages/' + stem + '/index.html'
    c = Command(htmlf, makof, render_mako())
    Depends(c, 'SConstruct')
    for d in Glob('Templates/*.mak'):
        Depends(c, d)

volumes = []
for yamlf in Glob('Volumes/*.yaml'):
    with open(str(yamlf)) as fil:
        vol = yaml.load(fil)
    volumes.append(vol)

c = Command('gh-pages/episodes/index.html', 'Templates/episodes.mak',
            render_mako(volumes=volumes))
Depends(c, 'SConstruct')
Depends(c, 'Templates/base.mak')

