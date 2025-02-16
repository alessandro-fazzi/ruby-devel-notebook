# Ruby Development Notebook

A Jupyter notebook environment for Ruby development, based on the official Jupyter minimal-notebook image with Ruby 3.4.2 support.

Created starting from https://github.com/RubyData/docker-stacks, but with updated ruby version and without all the
data science related dependencies. It also starts from the `minimal-notebook` jupyter's image.

## Features

- Ruby 3.4.2
- IRuby kernel for Jupyter notebooks
- Pre-installed development libraries

## Pre-installed Gems

- IRB 1.15.1 (Interactive Ruby Shell)
- IRuby 0.8.1 (Ruby kernel for Jupyter)
- Amazing Print 1.7.2 (Pretty printing)
- FFI-RZmq 2.0.7 (ZeroMQ bindings - requirement)

## Usage

### Building the Image

```bash
docker build -t ruby-devel-notebook .
```

### Running the Container

```bash
docker run --rm -p 8888:8888 -v "$PWD":/home/jovyan/work ruby-devel-notebook
```

The notebook will be available at http://localhost:8888. The token will be shown in the console output.

Save your notebooks in the `work/` folder in order to have them saved locally. Eventually tune the
`-v` flag to customize the local bind mount local path.

### Using Pre-built Image

You can run the pre-built image from GitHub Container Registry:

```bash
docker pull ghcr.io/alessandro-fazzi/ruby-devel-notebook
docker run --rm -p 8888:8888 -v "$PWD":/home/jovyan/work ghcr.io/alessandro-fazzi/ruby-devel-notebook
```

Available architectures:
- linux/amd64
- linux/arm64

### Building with Rake

To build and push multi-architecture images using Rake:

```bash
# Build and push latest version
GITHUB_USER=your-username rake release

# Build specific version
VERSION=1.0.0 rake release
```

The Rake tasks will:
- Set up Docker buildx
- Log into GitHub Container Registry
- Build both ARM64 and AMD64 images
- Push to GHCR
- Clean up build environment

You'll be prompted for a password while logging in to ghcr.io. You must supply
a correctly authorized personal access token.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

Copyright (c) 2024 Ruby Development Notebook Contributors
