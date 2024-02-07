#!/bin/bash

# jupyter-notebook --no-browser --port=5000
jupyter-notebook --no-browser --ip=0.0.0.0

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

