FROM ubuntu:20.04  # Or another suitable base image

# Install dependencies
RUN apt-get update && apt-get install -y \
    android-sdk \
    openjdk-11-jdk \
    tigervnc-standalone-server \
    novnc \
    && rm -rf /var/lib/apt/lists/*

# Environment variables
ENV ANDROID_HOME /opt/android-sdk
ENV PATH $PATH:$ANDROID_HOME/emulator:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools

# Accept licenses
RUN yes | sdkmanager --licenses

# Create emulator
RUN echo no | avdmanager create avd -n test -k "system-images;android-29;google_apis;x86" --force

# Start VNC server and noVNC web interface
CMD vncserver :1 && websockify --web /usr/share/novnc 6080 localhost:5901
