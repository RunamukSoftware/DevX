Use portal
(SELECT int_monitor.monitor_name, int_monitor.subnet
FROM int_patient_channel LEFT OUTER JOIN
int_monitor ON int_patient_channel.monitor_id = int_monitor.monitor_id
WHERE  (int_patient_channel.active_sw = 1) and int_monitor.monitor_id is not null and int_monitor.subnet is not null
group by int_monitor.monitor_name, int_monitor.subnet)
order by subnet
