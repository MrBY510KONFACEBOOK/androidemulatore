# Use Ubuntu as the base image
FROM ubuntu:20.04

# Install dependencies
RUN apt-get update && apt-get install -y \
    openjdk-8-jdk \
    wget \
    unzip \
    git \
    libgl1-mesa-glx \
    libpulse0 \
    libxcomposite1 \
    libxcursor1 \
    libxdamage1 \
    libxi6 \
    libxtst6 \
    libnss3 \
    libasound2 \
    libxrandr2 \
    python3 \
    python3-pip \
    xvfb \
    x11vnc \
    fluxbox \
    novnc \
    websockify

# Download and install Android SDK
RUN wget https://dl.google.com/android/repository/commandlinetools-linux-6858069_latest.zip -O sdk-tools.zip && \
    mkdir -p /opt/android-sdk/cmdline-tools && \
    unzip sdk-tools.zip -d /opt/android-sdk/cmdline-tools && \
    rm sdk-tools.zip

# Set environment variables
ENV ANDROID_SDK_ROOT=/opt/android-sdk
ENV PATH=$PATH:$ANDROID_SDK_ROOT/cmdline-tools/tools/bin:$ANDROID_SDK_ROOT/platform-tools

# Accept licenses
RUN yes | sdkmanager --licenses

# Install Android emulator and system images
RUN sdkmanager "platform-tools" "emulator" "platforms;android-30" "system-images;android-30;google_apis;x86_64"

# Create an Android Virtual Device (AVD)
RUN echo "no" | avdmanager create avd -n test -k "system-images;android-30;google_apis;x86_64" --device "pixel"

# Setup VNC server and noVNC
RUN mkdir -p /root/.vnc && \
    echo "password" | vncpasswd -f > /root/.vnc/passwd && \
    chmod 600 /root/.vnc/passwd

# Copy startup script
COPY startup.sh /root/startup.sh
RUN chmod +x /root/startup.sh

# Expose ports
EXPOSE 5900 6080

# Start the emulator and VNC server
CMD ["/root/startup.sh"]
