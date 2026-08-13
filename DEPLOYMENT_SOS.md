# Hermes Agent SOS deployment

## Services

- Dashboard: `http://192.168.1.18:9119`
- OpenAI-compatible Agent API: `http://192.168.1.18:8642/v1`
- Model route: `sos-openai` → `http://127.0.0.1:8080/v1` → `gpt-5.6`
- Publisher API: `http://192.168.1.18:5410`

Dashboard and both APIs require authentication. Runtime credentials are stored
in `data/.env` with mode `0600`; do not commit or copy that file into a
workflow definition.

## Operations

```bash
cd /opt/hermes-agent-SOS
docker compose -f docker-compose.sos.yml up -d
docker compose -f docker-compose.sos.yml ps
docker compose -f docker-compose.sos.yml logs -f
```

The first start after a rebuild can spend about two minutes remapping the
image's Python/Node files to the configured host UID. During that window the
container is `health: starting` and ports 8642/9119 are not ready yet.

## Publisher integration

The `social-auto-upload` skill is installed in
`data/skills/social-auto-upload/`. Hermes sees ComfyUI output at
`/workspace/comfyui-output` and media staging at
`/workspace/social-media-input`. The skill translates these to the publisher's
`/media/comfyui` and `/media/input` mounts.

Real upload jobs require both explicit user confirmation and
`confirm_publish: true`.

