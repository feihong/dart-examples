import os
import os.path as op
from mako.template import Template
from mako.lookup import TemplateLookup
import bottle
from invoke import run, task
from pathlib2 import Path, PurePath


GITHUB_USER = 'feihong'
SITE = '/dart-examples/'
IMPORTS = [
    'from filters import markdown, rst'
]

lookup = TemplateLookup(directories=['templates'])

app = bottle.Bottle()

if SITE != '/':
    @app.route('/')
    def index():
        return '<a href="%s">Go to site</a>' % SITE


@app.route(SITE)
@app.route(SITE + '<path:path>')
def page(path=''):
    file_ = get_file(path)
    if not file_.endswith('.html'):
        return bottle.static_file(path, root='site')
    return generate(file_, dev=True)


@task
def serve():
    from livereload import Server
    watcher = FileWatcher()
    watcher.watch('site', compile_dart)
    watcher.watch('templates')
    server = Server(app, watcher)
    server.serve(port=8000)


@task
def build():
    clean()
    buildjs()
    for src in Path('site').rglob('*?.*'):
        dest = Path('build') / src.relative_to('site')
        # The .es6 and .map files are useless in production.
        if dest.suffix in ('.es6', '.map'):
            continue
        print dest
        copy_or_generate(src, dest)


@task
def clean():
    if op.isdir('build'):
        run('rm -rf build/*')


@task
def publish():
    build()
    run('ghp-import -n -p build')


NEW_PAGE_HTML_TEMPLATE = u"""\
<%!
    title = ${title}
%>
<%inherit file='${template}' />

<div id='content'></div>
"""

NEW_PAGE_CODE_TEMPLATE = u"""\
import 'dart:html';

main() {
    var div = querySelector('#content');
    div.innerHtml = '''
      <p>Time to program!</p>
      <p>
        <button>Click me</button>
      </p>
    ''';
    querySelector('button').onClick.listen((evt) => window.alert('${title}'));
}
"""


@task
def new_page():
    from string import Template     # Use Python templates, not Mako templates

    slug = raw_input('Slug for page: ')
    title = raw_input('Title of page: ')
    template = raw_input('Template to inherit from (default is example.html): ')

    new_dir = Path('site') / slug
    if new_dir.exists():
        print '\nDirectory %s already exists, aborting' % new_dir
        return
    new_dir.mkdir()

    html_file = new_dir / 'index.html'
    with html_file.open('w') as fp:
        fp.write(Template(NEW_PAGE_HTML_TEMPLATE).substitute(
            title=repr(title.strip()), template=template.strip() or 'example.html'))

    js_file = new_dir / 'app.dart'
    with js_file.open('w') as fp:
        class_name = ''.join(s.capitalize() for s in title.split(' '))
        fp.write(Template(NEW_PAGE_CODE_TEMPLATE).substitute(title=title))


from livereload.watcher import Watcher

class FileWatcher(Watcher):
    "The watch callback function receives the path of the file that was changed."

    def examine(self):
        """Check if there are changes, if true, run the given task."""
        if self._changes:
            return self._changes.pop()

        # clean filepath
        self.filepath = None
        delays = set()
        for path in self._tasks:
            item = self._tasks[path]
            # If a file within a watched folder was changed, the value of
            # is_changed is the path to that file.
            is_changed = self.is_changed(path, item['ignore'])
            if is_changed:
                func = item['func']
                func and func(is_changed)
                delay = item['delay']
                if delay and isinstance(delay, int):
                    delays.add(delay)

        if delays:
            delay = max(delays)
        else:
            delay = None
        return self.filepath, delay

    def is_folder_changed(self, path, ignore=None):
        for root, dirs, files in os.walk(path, followlinks=True):
            for d in dirs[:]:
                if d.startswith('.'):
                    dirs.remove(d)

            for f in files:
                full_path = os.path.join(root, f)
                if self.is_file_changed(full_path, ignore):
                    return full_path    # return the full path instead of True
        return False


def compile_dart(path):
    from invoke import Failure
    if path.endswith('.dart'):
        parent = Path(path).parent
        src_path = parent / 'app.dart'
        out_path = parent / 'app.js'
        cmd = 'dart2js %s -o %s' % (src_path, out_path)
        print cmd
        try:
            result = run(cmd)
        except Failure as ex:
            out_path.write_text('document.write(`<pre>%s</pre>`)' % ex.result.stdout)

def get_file(path):
    result = op.join('site', path)
    if op.isfile(result):
        return result
    if op.isdir(result) and op.isfile(op.join(result, 'index.html')):
        return op.join(result, 'index.html')
    return 'site/404.html'


def get_slug(path):
    if path == 'site/index.html':
        return ''
    else:
        return str(PurePath(path).parent.name)


def generate(path, dev=False):
    template = Template(open(path).read(), lookup=lookup, imports=IMPORTS)
    return template.render(
        site=SITE,
        slug=get_slug(path),
        user=GITHUB_USER,
        DEV=dev)


def copy_or_generate(src, dest):
    import shutil
    if not dest.exists():
        dest.parent.mkdir(parents=True, exist_ok=True)
    if src.suffix == '.html':
        with dest.open('w') as fp:
            fp.write(generate(str(src)))
    else:
        shutil.copy(str(src), str(dest))
