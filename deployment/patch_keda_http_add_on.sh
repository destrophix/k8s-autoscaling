#!/bin/sh

DEPLOYMENT="keda-add-ons-http-interceptor"
NAMESPACE="default"

NAMES="KEDA_HTTP_CONNECT_TIMEOUT KEDA_RESPONSE_HEADER_TIMEOUT KEDA_HTTP_EXPECT_CONTINUE_TIMEOUT"
VALUES="5s 5s 5s"

# Get the current deployment JSON
DEPLOYMENT_JSON=$(kubectl get deployment "$DEPLOYMENT" -n "$NAMESPACE" -o json)

PATCH=""
i=1
count=$(echo "$NAMES" | wc -w)

for NAME in $NAMES; do
  VALUE=$(echo "$VALUES" | cut -d' ' -f$i)

  INDEX=$(echo "$DEPLOYMENT_JSON" | jq --arg name "$NAME" '
    .spec.template.spec.containers[0].env
    | to_entries[]
    | select(.value.name == $name)
    | .key' 2>/dev/null)

  if [ -n "$INDEX" ]; then
    ITEM="{\"op\": \"replace\", \"path\": \"/spec/template/spec/containers/0/env/$INDEX\", \"value\": {\"name\": \"$NAME\", \"value\": \"$VALUE\"}}"
  else
    ITEM="{\"op\": \"add\", \"path\": \"/spec/template/spec/containers/0/env/-\", \"value\": {\"name\": \"$NAME\", \"value\": \"$VALUE\"}}"
  fi

  if [ "$i" -eq "$count" ]; then
    PATCH="$PATCH$ITEM"
  else
    PATCH="$PATCH$ITEM,"
  fi

  i=$((i + 1))
done

PATCH="[$PATCH]"

# Apply the patch
echo "Applying patch..."
kubectl patch deployment "$DEPLOYMENT" -n "$NAMESPACE" --type='json' -p="$PATCH"
