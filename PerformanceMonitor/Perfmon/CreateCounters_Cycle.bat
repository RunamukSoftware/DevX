logman create counter SL_Baseline -cf "Baseline.cfg" -o "C:\PerfLogs\Spacelabs\Baseline.csv" -v mmddhhmm -f csv -si 00:00:10 -m start -b 00:00:05AM -rf 23:59:00 -r -y -rc "%CD%\CleanOlderLogs.cmd"
logman start SL_Baseline
cscript Server_settings.vbs