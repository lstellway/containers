FROM docker:24.0.5-dind-rootless

ENV \
  GITLAB_RUNNER_CONFIG=/home/rootless/.gitlab-runner/config.toml \
  GITLAB_RUNNER_WORKDIR=/var/lib/gitlab-runner \
  GITLAB_RUNNER_SERVICE=gitlab-runner

USER root

RUN apk add --no-cache \
  gitlab-runner parallel

# Create entrypoint for GitLab runner
RUN cat <<EOF > /usr/local/bin/start-gitlab-runner
#!/bin/sh
/usr/bin/gitlab-runner run \\
  --config \${GITLAB_RUNNER_CONFIG} \\
  --working-directory \${GITLAB_RUNNER_WORKDIR} \\
  --service \${GITLAB_RUNNER_SERVICE}
EOF

# Set permissions
RUN \
  chmod +x /usr/local/bin/start-gitlab-runner \
  && mkdir -p /var/lib/gitlab-runner $(dirname ${GITLAB_RUNNER_CONFIG}) \
  && chmod 770 /var/lib/gitlab-runner $(dirname ${GITLAB_RUNNER_CONFIG}) \
  && addgroup rootless gitlab-runner

USER rootless

# Create and use a Docker context
RUN \
  docker context create rootless --description "Docker rootless" --docker "host=unix:///run/user/$(id -u)/docker.sock" \
  && docker context use rootless

VOLUME [ "/home/rootless/.gitlab-runner" ]

# Original Docker entrypoint
# @see https://github.com/docker-library/docker/blob/f6bb49f0c0e7ed0ab489df14b53e26cc65c294d6/24/dind/Dockerfile#L88C14-L88C35
#
# Utilize parallel to run both processes in the foreground in parallel
# @see https://www.gnu.org/software/parallel/
ENTRYPOINT [ "parallel", "--line-buffer", ":::", "/usr/local/bin/start-gitlab-runner", "/usr/local/bin/dockerd-entrypoint.sh" ]

