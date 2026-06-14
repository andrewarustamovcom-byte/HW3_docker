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
    echo "    data/data.csv создан" ;;
  create_local_data)
    mkdir -p "$LOCAL_DATA_DIR"
    python3 "$PROJECT_DIR/generator/generate.py" "$LOCAL_DATA_DIR"
    echo "    local_data/data.csv создан" ;;
  build_reporter)
    docker build -t "$REPORTER_IMAGE" "$PROJECT_DIR/reporter" ;;
  run_reporter)
    mkdir -p "$DATA_DIR"
    docker run --rm -v "$DATA_DIR:/data" "$REPORTER_IMAGE"
    echo "    data/report.html создан" ;;
  structure)
    find "$PROJECT_DIR" | sort | sed "s|$PROJECT_DIR||" ;;
  clear_data)
    find "$DATA_DIR" -name "*.csv" -delete
    find "$DATA_DIR" -name "*.html" -delete
    echo "    data/ очищена" ;;
  inside_generator)
    mkdir -p "$DATA_DIR"
    docker run --rm -v "$DATA_DIR:/data" --entrypoint /bin/sh "$GENERATOR_IMAGE" \
      -c "python generate.py /data && echo '--- /data ---' && ls -lh /data" ;;
  inside_reporter)
    mkdir -p "$DATA_DIR"
    docker run --rm -v "$DATA_DIR:/data" --entrypoint /bin/sh "$REPORTER_IMAGE" \
      -c "echo '--- /data ---' && ls -lh /data" ;;
  report_server)
    docker run --rm -d --name dota2-report-server \
      -v "$DATA_DIR:/usr/share/nginx/html:ro" \
      -p 8080:80 nginx:alpine
    echo "    Сервер на порту 8080. Вкладка Ports → порт 8080 → Open in Browser → /report.html"
    echo "    Остановка: docker stop dota2-report-server" ;;
  *)
    echo "Команды: build_generator | run_generator | create_local_data"
    echo "         build_reporter  | run_reporter"
    echo "         structure | clear_data | inside_generator | inside_reporter | report_server" ;;
esac