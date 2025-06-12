# Autoware Topics

Topic | Type | Description
--- | --- | ---
/planning/mission_planning/goal | geometry_msgs/msg/PoseStamped | goal
/api/operation_mode/change_to_autonomous | autoware_adapi_v1_msgs/srv/ChangeOperationMode | autonomous
/api/operation_mode/change_to_stop | autoware_adapi_v1_msgs/srv/ChangeOperationMode | abort
/api/autoware/set/emergency | tier4_external_api_msgs/srv/SetEmergency | handbrake
/vehicle/status/turn_indicators_status | autoware_vehicle_msgs/msg/TurnIndicatorsReport | left/right indicators
/control/command/control_cmd | autoware_control_msgs/msg/Control | lateral/longitudinal control command

