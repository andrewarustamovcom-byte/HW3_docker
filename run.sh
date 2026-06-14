cat > run.sh << 'EOF'
#!/usr/bin/env bash
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GENERATOR_IMAGE="dota2-generator"
REPORTER_IMAGE="dota2-reporter"
DATA_DIR="$PROJECT_DIR/data"
LOCAL_DATA_DIR="$PROJECT_DIR/local_data"

case "$1" in
  build_generator)
    docker build -t "$GENERATOR_IMAGE" "$PROJECT_DIR/generator" ;;
  run_generator)
    mkdir -p "$DATA_DIR"
    docker run --rm -v "$DATA_DIR:/data" "$GENERATOR_IMAGE"
    echo "data/data.csv создан" ;;
  create_local_data)
    mkdir -p "$LOCAL_DATA_DIR"
    python3 "$PROJECT_DIR/generator/generate.py" "$LOCAL_DATA_DIR"
    echo "local_data/data.csv создан" ;;
esac
EOF
chmod +x run.sh