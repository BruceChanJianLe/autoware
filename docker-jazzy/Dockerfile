# Ubuntu 24.04 with cuda runtime
# FROM brucechanjianle/ubuntu24.04:v0.0.4-cnvros2-runtime
FROM brucechanjianle/cuda:12.4.1-runtime-ubuntu24.04
# FROM brucechanjianle/cuda:12.4.1-devel-ubuntu24.04

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install git -y

# Create autoware workspace and switch to directory
WORKDIR /home/developer/docker_mount

# Clone autoware repository
RUN git clone -b release/2025.02 https://github.com/BruceChanJianLe/autoware.git

# Switch to autoware directory
WORKDIR /home/developer/docker_mount/autoware

# RUN ./setup-dev-env.sh
RUN set -a \
    && . ./amd64.env \
    && set +a \
    && ./setup-dev-env.sh -y 
    # --no-nvidia

# Create src folder
RUN mkdir -p src
RUN vcs import src < jazzy.repos

RUN apt-get update \
    && apt-get upgrade -y

# Initialize rosdep
RUN rosdep init || true
RUN rosdep update

# Install ROS package dependencies
RUN rosdep install --from-paths src --ignore-src --rosdistro jazzy -r -y

# Build autoware workspace
RUN bash -c "source /opt/ros/jazzy/setup.bash && \
             colcon build --symlink-install --cmake-args -DCMAKE_BUILD_TYPE=Release"
 
# Set RMW implementation
RUN echo "export RMW_IMPLEMENTATION=rmw_cyclonedds_cpp" >> ~/.bashrc

# Set CycloneDDS URI
RUN echo "export CYCLONEDDS_URI=file:///home/developer/docker_mount/autoware/cyclonedds.xml" >> ~/.bashrc

# Create the sysctl config file for CycloneDDS
RUN echo "# Increase the maximum receive buffer size for network packets" > /etc/sysctl.d/10-cyclone-max.conf \
    && echo "net.core.rmem_max=2147483647" >> /etc/sysctl.d/10-cyclone-max.conf \
    && echo "" >> /etc/sysctl.d/10-cyclone-max.conf \
    && echo "# IP fragmentation settings" >> /etc/sysctl.d/10-cyclone-max.conf \
    && echo "net.ipv4.ipfrag_time=3" >> /etc/sysctl.d/10-cyclone-max.conf \
    && echo "net.ipv4.ipfrag_high_thresh=134217728" >> /etc/sysctl.d/10-cyclone-max.conf
