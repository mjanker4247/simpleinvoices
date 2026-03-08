#!/bin/bash
# deploy.sh — Build and run Simple Invoices locally.
# Supports Apple's native `container` CLI (macOS 26+) and traditional `docker`.
set -euo pipefail

# ── Configuration ────────────────────────────────────────────────────────────
APP_NAME="simpleinvoices"
MYSQL_CONTAINER="${APP_NAME}-mysql"
APP_CONTAINER="${APP_NAME}-app"
NETWORK="${APP_NAME}-net"
MYSQL_VOLUME="${APP_NAME}-mysql-data"
IMAGE="${APP_NAME}:latest"

DB_NAME="simple_invoices"
DB_USER="root"
DB_PASSWORD="rootpassword"
DB_PORT_HOST="3307"   # host port for MySQL (avoid conflict with local MySQL on 3306)
APP_PORT="8888"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ── Helpers ───────────────────────────────────────────────────────────────────
info()    { printf '\033[0;34m▶ %s\033[0m\n' "$*"; }
success() { printf '\033[0;32m✔ %s\033[0m\n' "$*"; }
warn()    { printf '\033[0;33m⚠ %s\033[0m\n' "$*"; }
die()     { printf '\033[0;31m✖ %s\033[0m\n' "$*" >&2; exit 1; }

usage() {
    cat <<EOF
Usage: $(basename "$0") [command]

Commands:
  up      Build image and start all containers (default)
  down    Stop and remove containers (data volume is kept)
  destroy Stop and remove containers AND the MySQL data volume
  build   Rebuild the application image only
  logs    Follow application logs
  shell   Open a shell in the running app container
  status  Show running containers
  help    Show this message
EOF
}

# ── Detect runtime ────────────────────────────────────────────────────────────
detect_runtime() {
    if command -v container &>/dev/null; then
        RUNTIME="container"
    elif command -v docker &>/dev/null; then
        RUNTIME="docker"
    else
        die "No container runtime found. Install Apple's 'container' CLI (macOS 26+) or Docker."
    fi
    info "Using runtime: $RUNTIME"
}

# ── Runtime-agnostic wrappers ─────────────────────────────────────────────────
rt()              { "$RUNTIME" "$@"; }
rt_build()        { rt build -t "$IMAGE" "$SCRIPT_DIR"; }
rt_network_up()   {
    if ! rt network ls 2>/dev/null | grep -q "$NETWORK"; then
        info "Creating network $NETWORK"
        rt network create "$NETWORK"
    fi
}
rt_volume_up()    {
    if ! rt volume ls 2>/dev/null | grep -q "$MYSQL_VOLUME"; then
        info "Creating volume $MYSQL_VOLUME"
        rt volume create "$MYSQL_VOLUME"
    fi
}
rt_container_running() { rt list 2>/dev/null | grep -q "$1" 2>/dev/null || rt ps 2>/dev/null | grep -q "$1"; }
rt_stop()         { rt stop "$1" 2>/dev/null || true; }
rt_rm()           { rt rm   "$1" 2>/dev/null || true; }

# ── Commands ──────────────────────────────────────────────────────────────────
cmd_build() {
    info "Building image $IMAGE ..."
    rt_build
    success "Image built: $IMAGE"
}

cmd_up() {
    rt_network_up
    rt_volume_up

    # ── MySQL ─────────────────────────────────────────────────────────────
    if rt_container_running "$MYSQL_CONTAINER"; then
        warn "MySQL container '$MYSQL_CONTAINER' is already running."
    else
        info "Starting MySQL container..."
        rt_stop "$MYSQL_CONTAINER"; rt_rm "$MYSQL_CONTAINER"

        rt run -d \
            --name "$MYSQL_CONTAINER" \
            --network "$NETWORK" \
            -e "MYSQL_ROOT_PASSWORD=${DB_PASSWORD}" \
            -e "MYSQL_DATABASE=${DB_NAME}" \
            -p "${DB_PORT_HOST}:3306" \
            -v "${MYSQL_VOLUME}:/var/lib/mysql" \
            -v "${SCRIPT_DIR}/databases/mysql:/docker-entrypoint-initdb.d" \
            mysql:8.0
        success "MySQL container started."
    fi

    # ── App image ─────────────────────────────────────────────────────────
    cmd_build

    # ── App container ─────────────────────────────────────────────────────
    if rt_container_running "$APP_CONTAINER"; then
        warn "App container '$APP_CONTAINER' is already running. Run './deploy.sh down' first to restart."
    else
        info "Starting app container..."
        rt_stop "$APP_CONTAINER"; rt_rm "$APP_CONTAINER"

        rt run -d \
            --name "$APP_CONTAINER" \
            --network "$NETWORK" \
            -p "${APP_PORT}:80" \
            -e "SI_DB_HOST=${MYSQL_CONTAINER}" \
            -e "SI_DB_PORT=3306" \
            -e "SI_DB_USER=${DB_USER}" \
            -e "SI_DB_PASSWORD=${DB_PASSWORD}" \
            -e "SI_DB_NAME=${DB_NAME}" \
            "$IMAGE"
        success "App container started."
    fi

    echo ""
    success "Simple Invoices is running!"
    echo "  App:         http://localhost:${APP_PORT}"
    echo "  MySQL:       localhost:${DB_PORT_HOST}  (user: ${DB_USER}, pass: ${DB_PASSWORD}, db: ${DB_NAME})"
    echo ""
    echo "  Logs:   ./deploy.sh logs"
    echo "  Shell:  ./deploy.sh shell"
    echo "  Stop:   ./deploy.sh down"
}

cmd_down() {
    info "Stopping containers..."
    rt_stop "$APP_CONTAINER";   rt_rm "$APP_CONTAINER"
    rt_stop "$MYSQL_CONTAINER"; rt_rm "$MYSQL_CONTAINER"
    success "Containers stopped and removed. MySQL data volume '${MYSQL_VOLUME}' retained."
}

cmd_destroy() {
    cmd_down
    info "Removing MySQL data volume..."
    rt volume rm "$MYSQL_VOLUME" 2>/dev/null || true
    success "Volume removed."
}

cmd_logs() {
    info "Following logs for $APP_CONTAINER (Ctrl-C to stop)..."
    rt logs -f "$APP_CONTAINER"
}

cmd_shell() {
    info "Opening shell in $APP_CONTAINER..."
    rt exec -it "$APP_CONTAINER" bash
}

cmd_status() {
    echo "=== Containers ==="
    rt list 2>/dev/null || rt ps 2>/dev/null || true
    echo ""
    echo "=== Networks ==="
    rt network ls 2>/dev/null || true
    echo ""
    echo "=== Volumes ==="
    rt volume ls 2>/dev/null || true
}

# ── Main ──────────────────────────────────────────────────────────────────────
detect_runtime

case "${1:-up}" in
    up)      cmd_up      ;;
    down)    cmd_down    ;;
    destroy) cmd_destroy ;;
    build)   cmd_build   ;;
    logs)    cmd_logs    ;;
    shell)   cmd_shell   ;;
    status)  cmd_status  ;;
    help|-h|--help) usage ;;
    *) die "Unknown command: $1. Run './deploy.sh help' for usage." ;;
esac
