#!/usr/bin/env bash
set -e

# 1) System update & install GitHub CLI
sudo apt-get update && sudo apt-get upgrade -y
sudo snap install gh --classic

# 2) GitHub auth (interactive)
gh auth login

# 3) Clone or update your repo
cd "$HOME"
if [ ! -d Udacity-Robotics-Software-Engineer-Nanodegree ]; then
  git clone https://github.com/JeromeyDynamics/Udacity-Robotics-Software-Engineer-Nanodegree
else
  cd Udacity-Robotics-Software-Engineer-Nanodegree
  git pull
fi

# 4) Global Git identity
git config --global user.name  "JeromeyDynamics"
git config --global user.email "jeromeydawinner@gmail.com"

# 5) Build every plugin project under any Course*/build folder
echo "🔨 Building all Gazebo plugins..."
find "$HOME/Udacity-Robotics-Software-Engineer-Nanodegree" -type f -name CMakeLists.txt | while read cmakeloc; do
  proj_dir=$(dirname "$cmakeloc")
  build_dir="$proj_dir/build"
  echo " • Building in $build_dir"
  mkdir -p "$build_dir"
  (cd "$build_dir" && cmake .. && make)
done

# 6) Append Gazebo model/plugin paths to ~/.bashrc if not already present
if ! grep -q "### Gazebo dynamic model/plugin paths ###" ~/.bashrc; then
  cat << 'EOF' >> ~/.bashrc

### Gazebo dynamic model/plugin paths ###
# Source the core Gazebo setup
source /usr/share/gazebo/setup.sh

# Dynamically include every */model directory two levels deep
MODEL_PATHS=$(find "$HOME/Udacity-Robotics-Software-Engineer-Nanodegree" -maxdepth 2 -type d -name model | paste -sd:)
export GAZEBO_MODEL_PATH=$MODEL_PATHS:$GAZEBO_MODEL_PATH

# Dynamically include every */build directory two levels deep
PLUGIN_PATHS=$(find "$HOME/Udacity-Robotics-Software-Engineer-Nanodegree" -maxdepth 2 -type d -name build | paste -sd:)
export GAZEBO_PLUGIN_PATH=$PLUGIN_PATHS:$GAZEBO_PLUGIN_PATH

### End Gazebo dynamic model/plugin paths ###
EOF
  # Activate immediately for the current session
  source ~/.bashrc
fi

echo "✅ Lab bootstrap complete! Navigate to your course folder and launch Gazebo (or gzserver) to get started."
