script = '/srv/start-gcp.sh'
subprocess.check_call(script)
from os.path import expanduser
home = expanduser("~")
client_file = '{}/.globusonline/lta/client-id.txt'.format(home)
with open(client_file, 'r') as f:
    line = f.readline()
    local_endpoint_uuid = line.strip()
    
# from globuscontents.globus_contents_manager import GlobusContentsManager
# c.NotebookApp.contents_manager_class = GlobusContentsManager
# c.NotebookApp.contents_manager_class.globus_local_endpoint = local_endpoint_uuid
# c.NotebookApp.contents_manager_class.globus_local_endpoint_cache_dir = 
# c.NotebookApp.contents_manager_class.globus_local_fs_cache_dir = 
