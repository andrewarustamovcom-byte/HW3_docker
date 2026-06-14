cat > generator/Dockerfile << 'EOF'
FROM python:3.12-slim
WORKDIR /app
COPY generate.py .
ENTRYPOINT ["python", "generate.py", "/data"]
EOF