#!/bin/bash
# Executar: yes | sudo sh ./Jupyter-Notebook-install.sh

# NOTA: Prefiero Jupyter Lab

sudo apt update
sudo apt install python3-pip python3-dev python3-venv -y
python3 -m venv my_env
source my_env/bin/activate
pip install jupyter

jupyter notebook --generate-config
echo "c.NotebookApp.ip = '0.0.0.0'" >> ~/.jupyter/jupyter_notebook_config.py
echo "c.NotebookApp.allow_origin = '*'" >> ~/.jupyter/jupyter_notebook_config.py