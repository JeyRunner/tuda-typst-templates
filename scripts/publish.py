import pathspec
import argparse
import os
import toml
import shutil
import pathlib
import re



# gitignore style pattern relative to repo root
publish_ignore_files = """
/example_tudapub.pdf

/.git/
/scripts/
/templates/tudapub/fonts
/templates/tudapub/logos
/tests/
/tud_design_guide/

/template_examples/logos/*
!/template_examples/logos/*.sh
/template_examples/fonts/*
!/template_examples/fonts/*.sh

"""


# set working dir to repo root
script_folder = os.path.dirname(os.path.realpath(__file__))
repo_root = script_folder + '/..'
os.chdir(repo_root)

ignore_pattern = pathspec.PathSpec.from_lines(
    pathspec.patterns.GitWildMatchPattern, 
    publish_ignore_files.splitlines()
)



# cmd args
parser = argparse.ArgumentParser(
    prog='Typst Package Publisher',
    description='Copies this repo to typst local packages or locally cloned typst-packages while not copying the ignored files.'
)
parser.add_argument('--local', action='store_true', 
                    help='copy to $HOME/.local/share/typst/packages/local/<PACKAGE_NAME>/<VERSION>.99')
parser.add_argument('--universe', type=str, 
                    help='copy to GIVEN_TYPST_PACKAGES_LOCAL_REPO_PATH//<PACKAGE_NAME>/<VERSION>',
                    metavar='GIVEN_TYPST_PACKAGES_LOCAL_REPO_PATH')
parser.add_argument('--not-clean-dist-folder', action='store_true', 
                    help='Not delete the contents of the destinatio folder before copying.')
args = parser.parse_args()


# get copy destination
copy_dest_dir = None
if not (args.local ^ (args.universe is not None)):
    print('Error: you must either set target to local or universe')
    parser.print_usage()
    exit(0)

if args.local:
    copy_dest_dir = str(pathlib.Path.home()) + "/.local/share/typst/packages/local/"
elif args.universe is not None:
    copy_dest_dir = args.universe + '/packages/preview/'


# read typt.toml
typst_toml = toml.load('typst.toml')
package_name = typst_toml['package']['name']
package_version = typst_toml['package']['version']
package_repository = typst_toml['package']['repository']

copy_dest_dir += f"{package_name}/{package_version}"

print(f'>> will copy to {copy_dest_dir} ...')


if (not args.not_clean_dist_folder) and pathlib.Path(copy_dest_dir).exists():
    print(f'>> first will remove all in {copy_dest_dir} ...')
    if input('>> Are you sure to remove this folder? [n/y]') != 'y':
        exit(1)
    shutil.rmtree(copy_dest_dir)

os.makedirs(copy_dest_dir, exist_ok=True)

for match in ignore_pattern.match_tree_files(root=repo_root, negate=True):
    dest = copy_dest_dir + '/' + match
    print(f'  - copy {match} to {dest}')
    os.makedirs(pathlib.Path(dest).parent, exist_ok=True)
    shutil.copy(match, dest)


# replace links in readme -> add full repo path in front
links_to_replace_with_repo_path = [
    'example_tudapub.pdf',
    'example_tudapub.typ',
    'templates/tudapub/tudapub.typ',
]
repo_path = ""
print('\n>> will replace links in the REAMDME.md')
link_regex = re.compile(r'\[([^\]]+)\]\(([^)]+)\)')
with open(copy_dest_dir + "/README.md", "r+") as readme:
    c = readme.read()
    links = list(link_regex.finditer(c)) #findall(c))
    
    def replace(match):
        out_full = match.group()
        out_split = out_full.split('(')
        assert len(out_split) == 2, "can't parse link: " + out_full
        for replace_str in links_to_replace_with_repo_path:
            out_split[-1] = out_split[-1] .replace(replace_str, package_repository + '/blob/main/' + replace_str)
        out_full = '('.join(out_split)
        print('  - new link: ' + out_full)
        return out_full

    c = link_regex.sub(replace, c)

    # overwrite
    readme.seek(0)
    readme.write(c)
    readme.truncate()