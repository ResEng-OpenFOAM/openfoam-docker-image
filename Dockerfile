FROM ubuntu:bionic
RUN  apt update && apt install -y build-essential flex bison git-core cmake zlib1g-dev libboost-system-dev libboost-thread-dev libopenmpi-dev openmpi-bin gnuplot libreadline-dev libncurses-dev libxt-dev
RUN  apt install -y libqt5x11extras5-dev libxt-dev qt5-default qttools5-dev curl
RUN  git clone --depth 1 https://github.com/OpenFOAM/OpenFOAM-dev.git /opt/OpenFOAM-dev
RUN  git clone --depth 1 https://github.com/OpenFOAM/ThirdParty-dev.git /opt/ThirdParty-dev
COPY ./0001-Fix-build-for-s390x.patch .
RUN  git config --global user.email "you@example.com"
RUN  git config --global user.name "Your Name"
RUN  bash -c "cd /opt/OpenFOAM-dev; git am /0001-Fix-build-for-s390x.patch"
RUN  bash -c "source /opt/OpenFOAM-dev/etc/bashrc; cd /opt/ThirdParty-dev; wmRefresh; ./Allwmake"
RUN  bash -c "cd /opt/OpenFOAM-dev; source etc/bashrc; wmRefresh; ./Allwmake"
RUN  echo "source /opt/OpenFOAM-dev/etc/bashrc" >> /etc/bash.bashrc
RUN  DEBIAN_FRONTEND=noninteractive apt-get install -y jupyter && apt autoclean
RUN  useradd -ms /bin/bash of
USER of
WORKDIR /home/of
