# Configuration file for lab.
c = get_config()  #noqa
c.ServerApp.password = 'YOUR PASSWORD'
c.ServerApp.allow_remote_access = True
c.NotebookApp.allow_origin = '*' # allow all origins
c.NotebookApp.ip = '0.0.0.0' # listen on all IPs
