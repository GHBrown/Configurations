import subprocess as sub

envs_file='envs.txt'
# get current environments in file
sub.check_call(" ".join(['conda','env','list','>',envs_file]),shell=True)

# load and parse environment names
with open(envs_file,'r') as f:
    lines = f.readlines()
env_lines = lines[2:-1] #first two lines and last line contain no env info
env_names = [line.split()[0] for line in env_lines] #first column contains env name

# write environment packages out
for env in env_names:
    print("Backing up...",env)
    cmd = "conda env export --name %s > conda_ymls/%s.yml" % (env,env)
    sub.check_call(cmd,shell=True)

#delete envs_file
sub.check_call('rm -f '+envs_file,shell=True) 
