# docker-ionic
An image to be used with Gitlab CI including 

- Ionic CLI 5
- Cordova 9
- node & npm
- Java 8 (OpenJDK)
- Android SDK
- Gradle
- Docker Garbage Collection to remove Containers that exited more than an hour ago

----

### Pull from Docker Hub
```
docker pull marcomaisel/ionic:latest
```

### Build from GitHub Repository
```
docker build -t marcomaisel/ionic github.com/marcomaisel/docker-ionic
```

### Run image
```
docker run -it marcomaisel/ionic bash
```

### Use as base image
```Dockerfile
FROM marcomaisel/ionic:latest
```

-----

### Inspired by
https://github.com/marcoturi/ionic-docker

### Docker Garbage Collection by
https://github.com/spotify/docker-gc
