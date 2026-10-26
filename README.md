# nav2-demo

TurtleBot3 (waffle) navigating autonomously in Gazebo with Nav2, avoiding obstacles that are not on the saved map.

Demo video: https://drive.google.com/file/d/1bd60gDsRpB-0oLOYCyxJKOmJUDAm3z7C/view?usp=sharing

## Prerequisites
Ubuntu 24.04 (or WSL2) with ROS 2 Jazzy and a working Gazebo (gz sim).

## Install
```bash
sudo apt update
sudo apt install ros-jazzy-navigation2 ros-jazzy-nav2-bringup \
  ros-jazzy-turtlebot3 ros-jazzy-turtlebot3-gazebo \
  ros-jazzy-turtlebot3-navigation2 ros-jazzy-ros-gz
echo "source /opt/ros/jazzy/setup.bash" >> ~/.bashrc
echo "export TURTLEBOT3_MODEL=waffle" >> ~/.bashrc
source ~/.bashrc
```

## Run
1. Terminal 1: `ros2 launch nav2_bringup tb3_simulation_launch.py headless:=False`
2. Terminal 2, once AMCL warns "Please set the initial pose": `bash scripts/set_initial_pose.sh`
3. Wait for "Managed nodes are active" and the Navigation 2 panel showing active/active.
4. In RViz, click **Nav2 Goal** on a free (white/pink) area and drag for heading.

## Obstacle demo
While the robot drives to a goal, drop a box in its path:
```bash
bash scripts/spawn_ahead.sh 1.2
```
The lidar detects the box (not in the saved map), the costmap updates, and Nav2 replans around it.

## Troubleshooting notes
- `Action server is inactive. Rejecting the goal`: no initial pose yet, so navigation never activated.
- `Failed to create plan`: the initial pose was wrong (inside a wall or pillar). Publish the exact spawn pose instead of dragging.
- Obstacle invisible in RViz: it was spawned outside the walls, so the lidar could not see it.
