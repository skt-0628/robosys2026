#!/bin/bash

# yoloinspect automatic test

PASS=0
FAIL=0

echo "===== YOLOINSPECT TEST START ====="

# Generate test image
TEST_IMAGE=$(mktemp --suffix=.jpg)
trap 'rm -f "$TEST_IMAGE"' EXIT

python3 - "$TEST_IMAGE" <<'PY'
import sys
from PIL import Image

Image.new("RGB", (640, 480), "white").save(sys.argv[1])
PY

# Test 1: Normal image
echo "[Test 1] Normal image"
output=$(./yoloinspect "$TEST_IMAGE" 2>&1)
status=$?

if [ "$status" -eq 0 ] &&
   echo "$output" | grep -q "YOLO Object Detection Results" &&
   echo "$output" | grep -q "Total objects:"; then
    echo "PASS"
    PASS=$((PASS + 1))
else
    echo "FAIL"
    echo "$output"
    FAIL=$((FAIL + 1))
fi

# Test 2: Nonexistent image
echo "[Test 2] Nonexistent image"
output=$(./yoloinspect nonexistent.jpg 2>&1)
status=$?

if [ "$status" -ne 0 ] &&
   echo "$output" | grep -qF "Error: image file not found."; then
    echo "PASS"
    PASS=$((PASS + 1))
else
    echo "FAIL"
    echo "$output"
    FAIL=$((FAIL + 1))
fi

# Test 3: Invalid threshold
echo "[Test 3] Invalid threshold"
output=$(./yoloinspect -t 1.5 "$TEST_IMAGE" 2>&1)
status=$?

if [ "$status" -ne 0 ] &&
   echo "$output" | grep -qF "Error: threshold must be between 0 and 1."; then
    echo "PASS"
    PASS=$((PASS + 1))
else
    echo "FAIL"
    echo "$output"
    FAIL=$((FAIL + 1))
fi

# Test 4: No image path
echo "[Test 4] No image path"
output=$(./yoloinspect </dev/null 2>&1)
status=$?

if [ "$status" -ne 0 ] &&
   echo "$output" | grep -qF "Error: no image path provided."; then
    echo "PASS"
    PASS=$((PASS + 1))
else
    echo "FAIL"
    echo "$output"
    FAIL=$((FAIL + 1))
fi

# Test 5: Standard input
echo "[Test 5] Standard input"
output=$(echo "$TEST_IMAGE" | ./yoloinspect 2>&1)
status=$?

if [ "$status" -eq 0 ] &&
   echo "$output" | grep -q "Total objects:"; then
    echo "PASS"
    PASS=$((PASS + 1))
else
    echo "FAIL"
    echo "$output"
    FAIL=$((FAIL + 1))
fi

# Test summary
echo "===== YOLOINSPECT TEST END ====="
echo "PASS: $PASS"
echo "FAIL: $FAIL"

if [ "$FAIL" -gt 0 ]; then
    exit 1
fi

exit 0

