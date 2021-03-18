$Hname  = [System.Net.Dns]::GetHostEntry([System.Net.Dns]::GetHostName()) | select HostName

$Hname

$IPAdd = ipconfig | findstr IPv4
$IPAdd.split(":")
