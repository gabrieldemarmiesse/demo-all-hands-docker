from python_on_whales import docker

docker.compose.up(detach=True)

print("----------------------------")
print("Printing containers status:")
for container in docker.compose.ps():
    print(container.name, container.state.status)

print("------------------------------------------")
input("Press enter when you are done with the stack.")

docker.compose.down()
print("------------------------------------------")
print("Running containers:", docker.compose.ps())
