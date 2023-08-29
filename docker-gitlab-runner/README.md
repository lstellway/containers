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
