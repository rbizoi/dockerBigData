#!/usr/bin/env bash

import os
nomMachine = os.environ['NOM_MACHINE']
password = os.environ['SPARK_PASSWORD']
utilisateur = os.environ['SPARK_USER']

from jupyter_server.auth import passwd

with open(f'/home/{utilisateur}/.jupyter/jupyter_server_config.json','w') as fichier:
    fichier.write('''
{
  "IdentityProvider": {    
     "hashed_password": "''' + passwd(password) +'''"
  }
}
''')


with open(f'/home/{utilisateur}/.jupyter/jupyter_server_config.py','a') as fichier:
    fichier.write(f'''
c.ServerApp.ip = '{nomMachine}'
c.ServerApp.port = 8888
''')


with open(f'/home/{utilisateur}/.jupyter/jupyter_lab_config.py','a') as fichier:
    fichier.write(f'''
c.ServerApp.ip = '{nomMachine}'
c.ServerApp.port = 8888
''')


