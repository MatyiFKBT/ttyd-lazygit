# ttyd-lazygit

> [!WARNING]
> Anyone who can reach the port can read and modify the mounted repository. Do not expose it without authentication.

A small Docker image that serves [lazygit](https://github.com/jesseduffield/lazygit) in the browser through [ttyd](https://github.com/tsl0922/ttyd).

The container mounts a git repository at `/repo` and runs `ttyd -W lazygit` in that directory. Authentication is not included, so put a reverse proxy with OAuth in front of it.

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

```sh
docker compose up -d
```

Replace `/path/to/your/repo` with the absolute path of the repository to expose. Each container serves one repository, so run one service per repository.

## docker run

```sh
docker run -d \
  --name lazygit \
  -p 7681:7681 \
  -v /path/to/your/repo:/repo \
  ghcr.io/matyifkbt/ttyd-lazygit:latest
```

Open `http://localhost:7681` in a browser.

## Image tags

Images are published to GitHub Container Registry only for releases. Available tags are `latest`, `X`, `X.Y` and `X.Y.Z`, where `latest` and `X` always point to the newest release.

To build locally instead:

```sh
docker build -t ttyd-lazygit:latest .
```

## Notes

- Port `7681` is ttyd's default.
- The image sets `safe.directory '*'` for git so that a mounted repository owned by another UID works.
