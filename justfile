test:
    cargo fmt --all -- --check
    cargo clippy --all-targets -- -D warnings
    cargo audit
    cargo deny check all
    cargo test

pre-commit:
    ./scripts/scan-staged-secrets.sh
    cargo fmt --all
    cargo clippy --all-targets -- -D warnings
    cargo audit
    cargo deny check all
    cargo test

release *args:
    git pull --rebase
    cargo release {{args}}

install:
    cargo install --path .

docker-build:
    ./scripts/docker-build.sh


docker-deploy:
    COMPOSE_FILE=docker-compose.yml
    if [ -f compose.yaml ]; then
    COMPOSE_FILE=compose.yaml
    elif [ -f compose.yml ]; then
    COMPOSE_FILE=compose.yml
    elif [ -f docker-compose.yaml ]; then
    COMPOSE_FILE=docker-compose.yaml
    fi
    if command -v docker-compose >/dev/null 2>&1; then
    docker-compose -f "$COMPOSE_FILE" up -d --build
    else
    docker compose -f "$COMPOSE_FILE" up -d --build
    fi
