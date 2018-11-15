logman create counter SL_Baseline -cf "Baseline.cfg" -o "C:\PerfLogs\Spacelabs\Baseline.csv" -v mmddhhmm -f csv -si 00:00:10  -b 04/08/2014 00:00:05AM -e 04/08/2014 11:59:50PM -r -y -rc "%CD%\CleanOlderLogs.cmd" -u nt.mh.com\sladmin SLservice
logman start SL_Baseline
cscript Server_settings.vbs