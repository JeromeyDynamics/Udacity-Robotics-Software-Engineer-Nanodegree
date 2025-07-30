# File: ~/Udacity-Robotics-Software-Engineer-Nanodegree/setup_lab.sh
#!/usr/bin/env bash
set -e

# 1) System update & GH CLI
sudo apt-get update && sudo apt-get upgrade -y
sudo snap install gh --classic

# 2) GitHub auth (interactive)
gh auth login

# 3) Clone or update your repo
cd $HOME
if [ ! -d Udacity-Robotics-Software-Engineer-Nanodegree ]; then
  git clone https://github.com/JeromeyDynamics/Udacity-Robotics-Software-Engineer-Nanodegree
else
  cd Udacity-Robotics-Software-Engineer-Nanodegree
  git pull
fi

# 4) Global Git identity
git config --global user.name  "JeromeyDynamics"
git config --global user.email "jeromeydawinner@gmail.com"

# 5) Ensure Gazebo setup is sourced on each shell
if ! grep -q "Gazebo dynamic model/plugin paths" ~/.bashrc; then
  cat << 'EOF' >> ~/.bashrc

# Gazebo dynamic model & plugin paths
source /usr/share/gazebo/setup.sh

# export every */model folder under our repo
MODEL_PATHS=$(find $HOME/Udacity-Robotics-Software-Engineer-Nanodegree -maxdepth 2 -type d -name model | paste -sd:)
export GAZEBO_MODEL_PATH=$MODEL_PATHS:$GAZEBO_MODEL_PATH

# export every */build folder under our repo
PLUGIN_PATHS=$(find $HOME/Udacity-Robotics-Software-Engineer-Nanodegree -maxdepth 2 -type d -name build | paste -sd:)
export GAZEBO_PLUGIN_PATH=$PLUGIN_PATHS:$GAZEBO_PLUGIN_PATH

# End Gazebo dynamic model/plugin paths
EOF
  # activate immediately
  source ~/.bashrc
fi

echo "✅ Lab is bootstrapped. cd into your course folder and start Gazebo!"
