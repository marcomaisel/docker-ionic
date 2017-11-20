# docker-ionic
An image to be used with Gitlab CI including 

- Ionic 3
- Cordova
- node & npm
- Java
- Android SDK
- Gradle

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
