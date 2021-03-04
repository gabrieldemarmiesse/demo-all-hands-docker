from python_on_whales import docker


docker.swarm.init()
swarmpit_stack = docker.stack.deploy("swarmpit", compose_files=["./docker-compose.yml"])

print("Listing services:")
print(swarmpit_stack.services())

input("Press enter when you are done with the stack.")
print("Removing the stack and destroying the swarm.")
swarmpit_stack.remove()
docker.swarm.leave(force=True)
