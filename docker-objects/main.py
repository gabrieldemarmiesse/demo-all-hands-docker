from python_on_whales import docker

my_container = docker.run("ubuntu", ["sleep", "infinity"], detach=True)
print("Started", my_container.state.started_at)
print("Running", my_container.state.running)
my_container.kill()
my_container.remove()

my_image = docker.image.inspect("ubuntu")
print("CMD:", my_image.config.cmd)
