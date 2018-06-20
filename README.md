# Manifold Towers Server

## Development
The development server will automatically rebuild and restart once a go file changes.

### Run

1. Start docker container
```bash
docker-compose -f docker-compose.develop.yml up
```

### Generate Golang Proto File

1. Go into the docker container with docker exec
2. Run shell script in the docker container
```bash
sh ./scripts/generate-proto.sh
```
## Production

### Run

1. Start docker container
```bash
docker-compose up -d
```