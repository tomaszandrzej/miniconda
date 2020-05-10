#!/miniconda/bin/python3

import json
from os import path
from sys import argv
from notebook.auth import passwd
from string import ascii_letters, digits
from random import choices

if path.exists('/jupyter-config/jupyter_notebook_config.json'):
    print('jupyter config file found')
    exit(0)

if len(argv) == 1:
    print('generating random password')
    password = ''.join(choices(ascii_letters + digits, k=8))
    with open('/jupyter-config/pass.txt', 'w') as file:
        file.write(password)
    print('writing password to pass.txt in jupyter-config folder')
else:
    print('using provided password')
    password = argv[1]

nb_pass = passwd(password)

print('creating jupyter notebook config file')

config = {
	"NotebookApp": {
		"password": nb_pass,
    		"terminado_settings": {"shell_command": ["/bin/bash"]},
    		"quit_button": False
		}
	}

with open('/jupyter-config/jupyter_notebook_config.json', 'w') as file:
    json.dump(config, file, indent=4)


exit(0)
