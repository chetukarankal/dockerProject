#!/usr/bin/env bash
# wait-for-it.sh

host="$1"
port="$2"
shift 2
cmd="$@"

until nc -z "$host" "$port"; do
  echo "⏳ Waiting for $host:$port to be ready..."
  sleep 3
done

echo "✅ $host:$port is available. Starting app..."
exec $cmd
