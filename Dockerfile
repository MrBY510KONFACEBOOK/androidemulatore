# Use Ubuntu as the base image
FROM ubuntu:20.04

# Set environment variable to prevent interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    openjdk-11-jdk \
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
    websockify \
    tzdata

# Download and install Android SDK command-line tools
RUN mkdir -p /opt/android-sdk/cmdline-tools && \
    wget https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip -O /opt/android-sdk/cmdline-tools/tools.zip && \
    unzip /opt/android-sdk/cmdline-tools/tools.zip -d /opt/android-sdk/cmdline-tools && \
    rm /opt/android-sdk/cmdline-tools/tools.zip

# Set environment variables
ENV ANDROID_SDK_ROOT=/opt/android-sdk
ENV PATH=$PATH:$ANDROID_SDK_ROOT/cmdline-tools/cmdline-tools/bin:$ANDROID_SDK_ROOT/platform-tools

# Accept licenses
RUN yes | sdkmanager --licenses

# Install Android emulator and system images
RUN sdkmanager "platform-tools" "emulator" "platforms;android-30" "system-images;android-30;google_apis;x86_64"

# Create an Android Virtual Device (AVD)
RUN echo "no" | avdmanager create avd -n test -k "system-images;android-30;google_apis;x86_64" --device "pixel"

# Setup VNC server and noVNC
RUN mkdir -p /root/.vnc && \
    echo "password" | x11vnc -storepasswd stdin /root/.vnc/passwd && \
    chmod 600 /root/.vnc/passwd

# Copy startup script
COPY startup.sh /root/startup.sh
RUN chmod +x /root/startup.sh

# Expose ports
EXPOSE 5900 6080

# Start the emulator and VNC server
CMD ["/root/startup.sh"]
