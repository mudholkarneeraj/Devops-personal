docker rmi -f $(docker images -aq) ==> to delete all the images
 docker rmi -f $(docker images --filter "dangling=true" -q --no-trunc) ==> to remove all untagged images
