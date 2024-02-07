#!/bin/bash

# *Instalar Anaconda
mkdir Anaconda
wget -P ./Anaconda https://repo.anaconda.com/archive/Anaconda3-2023.03-1-Linux-x86_64.sh

# *Executar Anaconda:
bash ./Anaconda/Anaconda3-2023.03-1-Linux-x86_64.sh

# *You can now activate the installation by sourcing the ~/.bashrc file:
source ~/.bashrc

# *Once you have done that, you’ll be placed into the default base
# *programming environment of Anaconda, and your command prompt will change to be the following:
# *(base) CT-nombre@usuario$:


# *Although Anaconda ships with this default base programming environment,
# *you should create separate environments for your programs and to keep them isolated from each other.

# *You can further verify your install by making use of the conda command, for example with list:
conda list

# *Executar el anaconda navigator
# anaconda-navigator
# echo "export PATH=$PATH:/home/admin/anaconda3/bin">> ~/.bashrc2 
# *Replace youruserdirectory with your actual user directory name.

# *A) Instalar Jupyter Lab usando anaconda:
# conda install -c conda-forge jupyterlab

# *Executar:
# jupyter lab --no-browser --ip=0.0.0.0


# *B) Instalar Jupyter Notebook usando anaconda:
# conda install -c anaconda jupyter

# *Executar el JupN de anaconda:
# jupyter notebook


# *Instalar NodeJS y npm con anaconda
# conda install -c conda-forge nodejs
# conda install -c anaconda nodejs
# node --version
# npm install -g [email protected]

# conda install -c conda-forge nodejs
# conda install -c anaconda nodejs

# *Update:
# conda update conda
# conda update anaconda


# *A) Executar el script en primer plano:
# bash ./Jupyter-Notebook-start.sh

# *B) Executar el script en segundo plano:
# ./Jupyter-Notebook-start.sh &

# *C) You can use the nohup command to run your script in
# *the background even after you log out. Here’s how you can use it:
# nohup ./Jupyter-Notebook-start.sh &

# *Ver los programas que estan en segundo plano:
# jobs

# *To bring a specific background job into the foreground type:
# fg job_number

# *If there is only one job running in the background just enter:
# fg

# *To exit without stopping the running script after using the command fg, you can follow these steps:

# *1) Press “Ctrl + Z” to suspend the foreground job.
# *2) Type “bg” to run the job in the background.
# *3) Type “disown -h %job_number” to remove the job from the shell’s job control
# and mark it so that it is not subject to SIGHUP (hangup signal) when the shell terminates.

