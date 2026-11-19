# ttyd-lazygit

A small Docker image that serves [lazygit](https://github.com/jesseduffield/lazygit) in the browser through [ttyd](https://github.com/tsl0922/ttyd).

The container mounts a git repository at `/repo` and runs `ttyd -W lazygit` in that directory. Authentication is not included; put a reverse proxy with OAuth in front of it.

## Pinned versions

The base image and package versions are pinned directly in the `Dockerfile`:

- `FROM alpine:3.24`
- `ttyd=1.7.7-r0`, `lazygit=0.48.0-r14`, `git=2.54.1-r0`

[Renovate](https://docs.renovatebot.com/) keeps these up to date. `renovate.json` points the apk datasource at the Alpine 3.24 `main` and `community` repositories, so Renovate proposes package bumps for the `apk add` pins.

Alpine package revisions are removed from the repository once superseded. If a pin stops resolving, update it to the current revision (`apk search -v lazygit` inside an Alpine container shows what is available).

## Image

Published images are available on GitHub Container Registry:

```sh
docker pull ghcr.io/matyifkbt/ttyd-lazygit:latest
```

Tags: `latest`, `X`, `X.Y` and `X.Y.Z`. Images are published only for releases created by the release workflow, so `latest` and the major tag always point to the newest release.

To build locally instead:

```sh
docker build -t ttyd-lazygit:latest .
```

## Run

```sh
docker run -d \
  --name lazygit \
  -p 7681:7681 \
  -v /path/to/your/repo:/repo \
  ghcr.io/matyifkbt/ttyd-lazygit:latest
```

Open `http://localhost:7681` in a browser.

## docker-compose

`docker-compose.yml`:

```yaml
services:
  lazygit:
    image: ghcr.io/matyifkbt/ttyd-lazygit:latest
    ports:
      - "7681:7681"
    volumes:
      - /path/to/your/repo:/repo
    restart: unless-stopped
```

Start it with:

```sh
docker compose up -d
```

Replace `/path/to/your/repo` with the absolute path of the repository to expose. Only one repository is served per container; run several services with different mounts and ports to serve more than one.

## Notes

- Port `7681` is ttyd's default.
- The image sets `safe.directory '*'` for git so that a mounted repository owned by another UID works.
- Anything that can reach the port can read and modify the mounted repository. Do not expose it without authentication.
