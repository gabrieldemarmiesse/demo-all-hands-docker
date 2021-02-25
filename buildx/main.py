from python_on_whales import docker

my_image = docker.build(".", tags="some_name")


print("Listing all Docker images tags:")
for image in docker.image.list():
    print(image.repo_tags)
