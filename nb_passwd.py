#!/miniconda/bin/python3

import json
from os import path
from sys import argv
from notebook.auth import passwd


if len(argv) == 1:
    print('Password not given, exiting')
    exit(1)

if path.exists('/jupyter-config/jupyter_notebook_config.json'):
    print('configuration file exists, skipping')
    exit(0)


print('Generating notebook password')

nb_pass = passwd(argv[1])

print('creating jupyter notebook config file')

config = {
	"NotebookApp": {
		"password": nb_pass,
    		"terminado_settings": {"shell_command": ["/bin/bash"]},
    		"quit_button": False
		}
	}

with open('/jupyter-config/jupyter_notebook_config.json', 'w') as file:
    json.dump(config, file)


exit(0)

