forfiles /p "C:\PerfLogs\Spacelabs" /s /m *.csv /D -30 /C "cmd /c del @path"
