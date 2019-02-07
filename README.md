# Openstack-helm Auxiliary Dockerfiles
This repo contains supporting images for the development of
[Openstack Helm](https://github.com/openstack/openstack-helm).

## Building & Pushing Images
By default, the `Makefile` will print usage and exit.

To build all images:

```
make build
```

To build a specific image:

```
make build:<image>[:<tag>]
```

or:

```
make <image>[:<tag>]
```

To push all images:

```
make push
```

To push a specific image:

```
make push:<image>[:<tag>]
```

## Adding an Image
The following will add an image with a simplistic build process that only
executes `docker build ...` (see `Makefile.default` for details).

1. Make a directory for the new image that matches the desired image name.
2. Place the `Dockerfile` in that directory.
3. Edit the top-level `Makefile` to add a line for your image at the top.

```make
IMAGES := \
	... \
	new_image:latest \
	... \

```

### Customizing the Build Process
To customize the build process, you should first follow the steps for Adding an
Image above.

Then, you can control the build process by placing a `Makefile` in your image
directory right next to the `Dockerfile`.  This make file should have 2
targets: `build` and `push`.

The custom makefile will receive the following environment variables:

- `DEFAULT_NAMESPACE` - Currently this will always be `quay.io/attcomdev`.
- `DEFAULT_IMAGE` - This will be the name of the directory.
- `DEFAULT_TAG` - This will be the tag specified in the top level `Makefile`.
- `EXTRA_BUILD_ARGS` - This, if needed, can be overridden to pass build parameters to docker build
