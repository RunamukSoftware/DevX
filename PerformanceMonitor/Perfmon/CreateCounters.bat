logman create counter SL_Baseline -cf "Baseline.cfg" -o "C:\PerfLogs\Spacelabs\Baseline.csv" -v mmddhhmm -f csv -si 00:00:10 -m start -rf 48:00:00 -y
logman start SL_Baseline
cscript Server_settings.vbs