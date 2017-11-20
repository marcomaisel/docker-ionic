FROM debian:jessie

ENV DEBIAN_FRONTEND=noninteractive \
    ANDROID_HOME=/opt/android-sdk-linux

# Install git, curl, node, ionic, yarn
RUN apt-get update &&  \
    apt-get install -y wget git curl && \
    curl -sL https://deb.nodesource.com/setup_6.x | bash - && \
    apt-get update &&  \
    apt-get install -y nodejs && \
    npm install -g npm@"5.5.1" && \
    npm install -g cordova@"7.1.0" ionic@"3.18.0" yarn@"1.3.2" && \
    npm cache clear --force && \

    # install python-software-properties (to use add-apt-repository)
    apt-get update && apt-get install -y -q python-software-properties software-properties-common  && \

    # install java
    add-apt-repository "deb http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main" -y && \
    echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections && \
    apt-get update && apt-get -y install oracle-java8-installer && \

    # System libs for android enviroment
    echo ANDROID_HOME="${ANDROID_HOME}" >> /etc/environment && \
    dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y --force-yes expect ant wget libc6-i386 lib32stdc++6 lib32gcc1 lib32ncurses5 lib32z1 qemu-kvm kmod && \
    apt-get clean && \
    apt-get autoclean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \

    # Install Android Tools
    mkdir  /opt/android-sdk-linux && cd /opt/android-sdk-linux && \
    wget --output-document=android-tools-sdk.zip --quiet https://dl.google.com/android/repository/tools_r25.2.3-linux.zip && \
    unzip -q android-tools-sdk.zip && \
    rm -f android-tools-sdk.zip && \
    chown -R root. /opt

# Setup environment
ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools

# Install Android SDK
RUN yes Y | ${ANDROID_HOME}/tools/bin/sdkmanager "build-tools;25.0.2" "platforms;android-25" "platform-tools"
RUN cordova telemetry off

# Install Gradle
RUN wget https://services.gradle.org/distributions/gradle-3.4.1-bin.zip && \
    mkdir /opt/gradle && \
    unzip -d /opt/gradle gradle-3.4.1-bin.zip && \
    export PATH=$PATH:/opt/gradle/gradle-3.4.1/bin

WORKDIR Sources
EXPOSE 8100 35729
CMD ["ionic", "serve"]