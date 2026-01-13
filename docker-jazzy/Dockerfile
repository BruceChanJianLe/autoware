# Ubuntu 24.04 with cuda12.4
FROM brucechanjianle/cuda:12.4.1-devel-ubuntu24.04

# Remove non-root ubuntu
RUN touch /var/mail/ubuntu && chown ubuntu /var/mail/ubuntu && userdel -r ubuntu

# Set colorful prompt
ENV TERM=xterm-256color

# Set LANG in order to display emoji
ENV LANG=en_US.UTF-8

# Required for ansible
ENV LC_ALL=C.UTF-8

RUN apt-get update -qq \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y -qq \
    git \
    sudo \
    vim \
    tmux \
    unzip \
    lsb-release \
    && apt-get clean -qq

# Add a user with the same user_id as the user outside of the container
# Note that this requires a docker build argument `user_id`
ARG user_id
ENV USERNAME developer
RUN useradd -U --uid ${user_id} -ms /bin/bash $USERNAME \
    && echo "$USERNAME:$USERNAME" | chpasswd \
    && adduser $USERNAME sudo \
    && echo "$USERNAME ALL=NOPASSWD: ALL" >> /etc/sudoers.d/$USERNAME

# Commands below are run as developer user
USER $USERNAME

# Let the container starts in the developer's home folder
WORKDIR /home/$USERNAME

# Make a mounting directory
RUN mkdir -p /home/$USERNAME/docker_mount

# Export noninterative tzdata
RUN export DEBIAN_FRONTEND=noninteractive \
 && sudo apt-get update && sudo apt-get install -y tzdata

# Create autoware workspace and switch to directory
 # WORKDIR /root
WORKDIR /home/$USERNAME/docker_mount

# Clone autoware repository
RUN git clone -b release/2025.02 https://github.com/BruceChanJianLe/autoware.git

# Switch to autoware directory
# WORKDIR /root/autoware
WORKDIR /home/$USERNAME/docker_mount/autoware

RUN set -a \
    && . ./amd64.env \
    && set +a \
    && ./setup-dev-env.sh -y 

# Create src folder
RUN mkdir -p src
RUN vcs import src < jazzy.repos

RUN sudo apt-get update && sudo apt-get upgrade -y

# Initialize rosdep
RUN rosdep init || true
RUN rosdep update

# Install ROS package dependencies
RUN rosdep install --from-paths src --ignore-src --rosdistro jazzy -r -y

# Build autoware workspace
RUN bash -c "source /opt/ros/jazzy/setup.bash && \
             colcon build --symlink-install --cmake-args -DCMAKE_BUILD_TYPE=Release"
 
# Set CycloneDDS URI
RUN echo "export CYCLONEDDS_URI=file:///root/autoware/cyclonedds.xml" >> ~/.bashrc
