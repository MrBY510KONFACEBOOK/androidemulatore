#!/bin/bash

# Start the X server
Xvfb :0 -screen 0 1280x800x16 &

# Start the window manager
fluxbox &

# Start the Android emulator
$ANDROID_SDK_ROOT/emulator/emulator -avd test -no-audio -no-boot-anim -gpu swiftshader_indirect -no-snapshot -skin 1280x800 &

# Wait for the emulator to start
sleep 60

# Start the VNC server
x11vnc -display :0 -forever -shared -passwd password &

# Start noVNC
websockify --web=/usr/share/novnc 6080 localhost:5900
