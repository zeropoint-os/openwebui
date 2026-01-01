#!/bin/bash

# Test script for OpenWebUI container

# Get the IP address of the openwebui-main container
OPENWEBUI_IP=$(docker inspect openwebui-main --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' 2>/dev/null)

if [ -z "$OPENWEBUI_IP" ]; then
    echo "Error: openwebui-main container not found or not running"
    exit 1
fi

echo "Found openwebui-main at IP: $OPENWEBUI_IP"
echo "Testing OpenWebUI web interface..."
echo ""

# Test 1: Check if OpenWebUI is responding
echo "Step 1: Checking OpenWebUI health..."
STATUS_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://$OPENWEBUI_IP:8080/health || echo "000")
if [ "$STATUS_CODE" = "200" ]; then
    echo "✓ OpenWebUI is healthy (HTTP $STATUS_CODE)"
else
    echo "⚠ OpenWebUI health check returned HTTP $STATUS_CODE"
fi
echo ""

# Test 2: Check the main web interface
echo "Step 2: Checking main web interface..."
STATUS_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://$OPENWEBUI_IP:8080/ || echo "000")
if [ "$STATUS_CODE" = "200" ]; then
    echo "✓ OpenWebUI web interface is accessible (HTTP $STATUS_CODE)"
else
    echo "⚠ OpenWebUI web interface returned HTTP $STATUS_CODE"
fi
echo ""

echo "Test complete!"
echo "You can access OpenWebUI at: http://$OPENWEBUI_IP:8080"
echo "Note: You may need to configure an Ollama endpoint in the settings."
