# GitLab Runner with Docker

A [Docker in Docker](https://www.docker.com/blog/docker-can-now-run-within-docker/) container image containing [GitLab Runner](https://docs.gitlab.com/runner/) to be used as a [Docker executor](https://docs.gitlab.com/runner/executors/docker.html). 

## Environment Variables

| Name                    | Description                                                                                            |
| ---                     | ---                                                                                                    |
| `GITLAB_RUNNER_CONFIG`  | Path to the GitLab Runner configuration file.<br />Default `/home/rootless/.gitlab-runner/config.toml` |
| `GITLAB_RUNNER_WORKDIR` | GitLab runner working directory.<br />Default `/var/lib/gitlab-runner`                                 |
| `GITLAB_RUNNER_SERVICE` | gitlab-runner                                                                                          |
| `DOCKER_HOST`           | Defaults to Docker `rootless` socket:<br />`unix:///run/user/1000/docker.sock`                         |

## Usage

An example [`docker-compose.yml`](./docker-compose.yml) file exists to show how to use with Docker Compose.<br />
To run directly with Docker:

```sh
# Create a volume for persistent storage
docker volume create gitlab-runner-data

# Run the container
docker run --privileged \
  --name gitlab-runner \
  --volume "gitlab-runner-data:/home/rootless/.gitlab-runner" \
  ghcr.io/lstellway/docker-gitlab-runner:latest
```

### Recommendations

[According to GitLab](https://gitlab.com/gitlab-org/gitlab-runner/-/blob/main/docs/executors/docker.md#use-rootless-docker-in-docker-with-restricted-privileged-mode), it is good practice to restrict which containers can run in privileged mode.

```toml
[[runners]]
  executor = "docker"
  [runners.docker]
    services_privileged = true
    allowed_privileged_services = ["docker.io/library/docker:*-dind-rootless", "docker.io/library/docker:dind-rootless", "docker:*-dind-rootless", "docker:dind-rootless"]
    volumes = ["/cache", "/certs/client", "/var/lib/docker"]
```

### Troubleshooting

If you receive an error like this:

```
[rootlesskit:parent] error: failed to setup UID/GID map: newuidmap 4013 [0 1001 1 1 165536 65536] failed: newuidmap: write to uid_map failed: Operation not permitted
```

Edit `/etc/subuid` and `/etc/subgid` to ensure you [allocate a sufficient number of ID's](https://discuss.linuxcontainers.org/t/unable-to-run-rootless-docker-podman-under-a-rootless-lxd-container/15276/4) on the host machine for the user running Docker.

