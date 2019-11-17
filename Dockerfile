FROM debian:buster

ENV DEBIAN_FRONTEND=noninteractive \
    ANDROID_HOME=/opt/android-sdk-linux
    
# Set the locale
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y locales

RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8

ENV LANG en_US.UTF-8 

# Install git, curl, node, ionic, yarn, Chrome
RUN apt-get update &&  \
    apt-get install -y wget git unzip curl ruby ruby-dev build-essential && \
    curl -sL https://deb.nodesource.com/setup_10.x | bash - && \
    apt-get update &&  \
    apt-get install -y nodejs && \
    npm install -g cordova@"8.1.0" ionic@"5.4.6" yarn@"1.19.1" && \
    npm cache clear --force && \
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
    dpkg --unpack google-chrome-stable_current_amd64.deb && \
    apt-get install -f -y && \
    apt-get clean && \
    rm google-chrome-stable_current_amd64.deb
    
# Install Docker for Garbage Collection
RUN apt-get install apt-transport-https ca-certificates curl gnupg2 software-properties-common -y && \
    curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg | apt-key add - && \
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") $(lsb_release -cs) stable" && \
    apt-get update && \
    apt-get install docker-ce -y

# Install fastlane
RUN gem install bundler && \
    gem install fastlane -NV

# Install java8 required by android (OpenJDK because Oracle's can't be easily downloaded)
RUN add-apt-repository "deb http://ftp.us.debian.org/debian sid main" && \
    apt-get update && \
    apt-get install -y openjdk-8-jdk

# System libs for android enviroment
RUN echo ANDROID_HOME="${ANDROID_HOME}" >> /etc/environment && \
    dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y expect ant libc6-i386 lib32stdc++6 lib32gcc1 lib32ncurses6 lib32z1 qemu-kvm kmod && \
    apt-get clean && \
    apt-get autoclean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
    # Install Android Tools
RUN mkdir  /opt/android-sdk-linux && cd /opt/android-sdk-linux && \
    wget --output-document=android-tools-sdk.zip --quiet https://dl-ssl.google.com/android/repository/tools_r25.2.5-linux.zip && \
    unzip -q android-tools-sdk.zip && \
    rm -f android-tools-sdk.zip && \
    chown -R root. /opt

# Setup environment
ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools

# Install Android SDK
RUN yes Y | ${ANDROID_HOME}/tools/bin/sdkmanager "build-tools;28.0.3" "platforms;android-28" "platform-tools"
RUN cordova telemetry off

# Install Gradle
RUN wget https://services.gradle.org/distributions/gradle-4.10.3-bin.zip && \
    mkdir /opt/gradle && \
    unzip -d /opt/gradle gradle-4.10.3-bin.zip && \
    export PATH=$PATH:/opt/gradle/gradle-4.10.3/bin

# Install docker-gc (garbage collector)
RUN apt-get update
RUN apt-get install git devscripts debhelper build-essential dh-make -y
RUN git clone https://github.com/spotify/docker-gc.git /root/docker-gc
RUN cd /root/docker-gc && debuild -us -uc -b
RUN dpkg -i /root/docker-gc_0.2.0_all.deb

# Install docker-compose
RUN curl -L https://github.com/docker/compose/releases/download/1.24.1/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
RUN chmod +x /usr/local/bin/docker-compose

WORKDIR Sources
EXPOSE 8100 35729
CMD ["ionic", "serve"]
