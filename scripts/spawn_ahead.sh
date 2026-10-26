#!/bin/bash
# Usage: spawn_ahead.sh [distance_m]   (drops a box ahead of the robot)
source /opt/ros/jazzy/setup.bash
DIST=${1:-1.2}
NAME=box_$(date +%s)
read X Y < <(python3 - "$DIST" << 'PY'
import sys, math, rclpy
from rclpy.node import Node
from rclpy.qos import QoSProfile, DurabilityPolicy, ReliabilityPolicy
from geometry_msgs.msg import PoseWithCovarianceStamped
rclpy.init(); n = Node('spawn_helper'); res = {}
def cb(m):
    p = m.pose.pose; q = p.orientation
    yaw = math.atan2(2*(q.w*q.z+q.x*q.y), 1-2*(q.y*q.y+q.z*q.z))
    res['v'] = (p.position.x, p.position.y, yaw)
qos = QoSProfile(depth=1, durability=DurabilityPolicy.TRANSIENT_LOCAL, reliability=ReliabilityPolicy.RELIABLE)
n.create_subscription(PoseWithCovarianceStamped, '/amcl_pose', cb, qos)
while 'v' not in res: rclpy.spin_once(n, timeout_sec=0.5)
x, y, yaw = res['v']; d = float(sys.argv[1])
print(x + d*math.cos(yaw), y + d*math.sin(yaw))
PY
)
ros2 run ros_gz_sim create -world default -name $NAME -x $X -y $Y -z 0.25 -string '<sdf version="1.9"><model name="'$NAME'"><static>true</static><link name="link"><collision name="c"><geometry><box><size>0.5 0.5 0.5</size></box></geometry></collision><visual name="v"><geometry><box><size>0.5 0.5 0.5</size></box></geometry><material><ambient>1 0 0 1</ambient><diffuse>1 0 0 1</diffuse></material></visual></link></model></sdf>'
echo "Spawned $NAME at $X $Y"
