
#!/bin/bash

# yoloinspect automatic test

echo "===== YOLOINSPECT TEST START ====="

# Test 1: Normal image
echo "[Test 1] Normal image"
./yoloinspect test_image.jpg
if [ $? -eq 0 ]; then
    echo "PASS"
else
    echo "FAIL"
fi

# Test 2: Nonexistent image
echo "[Test 2] Nonexistent image"
./yoloinspect nonexistent.jpg
if [ $? -ne 0 ]; then
    echo "PASS"
else
    echo "FAIL"
fi

# Test 3: Invalid threshold
echo "[Test 3] Invalid threshold"
./yoloinspect -t 1.5 test_image.jpg
if [ $? -ne 0 ]; then
    echo "PASS"
else
    echo "FAIL"
fi

# Test 4: No image path
echo "[Test 4] No image path"
./yoloinspect
if [ $? -ne 0 ]; then
    echo "PASS"
else
    echo "FAIL"
fi

echo "===== YOLOINSPECT TEST END ====="

