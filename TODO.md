
Dev

```
docker run -it -v $(pwd)/src:/mnt zcall:latest /bin/bash
# cp stuff
```

Build

```
docker build -t zcall .
```

Run

```
docker run -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=$DISPLAY
```
