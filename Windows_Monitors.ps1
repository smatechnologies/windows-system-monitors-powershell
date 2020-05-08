param
(
    [String]$server = $env:ComputerName,     #Server name
    [String]$load,       #CPU usage,
    [String]$drive,      #drive letter to check space of
    [String]$freespace,  #amount of free space desired (in percent)
    [String]$amount,     #amount of free ram desired
    [String]$servicename,#name of service to check the status of, wildcards supported
    [String]$monitor,    #Which monitor to use
    [String]$process,    #Name of process you want to monitor
    [String]$port,       #Port you want to monitor
    [String]$disk,       #Disk that you want information on or to resize
    [String]$partition,  #Partition that you want to resize
    [String]$size        #Size in GB that you want to resize the partition too
)

<#
# Test variables
$monitor = "loggedonusers"
$load = 70
$amount = 4000
$serviceName = "SMA*"
$process = "7zip"
#$server = "bing.com"
$port = "8181"
#>


if($monitor -eq "cpu")
{
    #Checks CPUs
    Get-WmiObject -ComputerName $server Win32_Processor -Property LoadPercentage | foreach-object -Process{ 
      if ($_.LoadPercentage -gt $load) 
      { 
        Write-Host "CPU Exceeded $load% `r"
        Exit $_.LoadPercentage
      } 
      else
      {
        Write-Host "CPU load:"$_.LoadPercentage "`r"
      }
    }
}
elseif($monitor -eq "disk")
{
    #Checks disk space
    #1073741824 bytes per gb if doing in GB instead of percent

    $available = (((Get-WmiObject Win32_LogicalDisk -ComputerName $server -Filter "DeviceID='${drive}:'").FreeSpace)/((Get-WmiObject Win32_LogicalDisk -ComputerName $server -Filter "DeviceID='${drive}:'").Size)) * 100
    $trimmed = $available -as [int]

    #Checks amount of free disk space 
    if ($available -lt $freespace)
    {
      write-host "Low Disk Space! -- $server $drive drive, $trimmed% free"
      Exit $trimmed
    }
    else
    {
        write-host "$trimmed% free on $server $drive drive"
    }
}
elseif($monitor -eq "ram")
{
    $freeRAM = (Get-WmiObject Win32_PerfRawData_PerfOS_Memory -ComputerName "$server").AvailableMbytes
    if ($freeRAM -lt $amount)
    {
        write-host "Low memory, only $freeRAM MB remaining!"
        Exit 100
    }
    else
    {
        write-host "Memory OK, $freeRAM MB remaining"
    }
}
elseif($monitor -eq "service")
{
    $services = Get-Service -ComputerName "$server" -Name "$servicename"
    $services | Format-Table Name,DisplayName,Status
}
elseif($monitor -eq "ping")
{
    #Pings a server to see if it is up
    if(test-connection -ComputerName "$server" -Quiet)
	{
		Write-Host "Connection to $server established"
    }
	else
	{	
		Write-Host "Unable to connect to $server"
		Exit 102
	}
}
elseif($monitor -eq "process")
{
    if(!(Get-Process -ComputerName $server | Where-Object { $_.ProcessName -like $process }))
    {
	    Write-Host "$process not running!"
	    Exit 100
    }
    else
    {
	    Write-Host "$process running!"
    }
}
elseif($monitor -eq "port")
{
    #Tests connection
    $connectionstats = Test-NetConnection -ComputerName $server -Port $port
    if ($connectionstats.PingSucceeded -notmatch 'True') 
    {
        write-host "ping fail"
        $exitcode = 1
    }
    elseif ($connectionstats.TcpTestSucceeded -notmatch 'True') 
    {
        write-host "tcp fail"
        $exitcode = 2
    }
    else 
    {
        write-host "success"
        $exitcode = 0
    }

    write-host "Exit code set to $exitcode"
    Exit $exitcode
}
elseif($monitor -eq "partition") 
{
    Get-Partition 
}
elseif($monitor -eq "resizePartition")
{
    Resize-Partition -DiskNumber $disk -PartitionNumber $partition -Size ("$size"+"GB")
}
elseif($monitor -eq "loggedOnUsers")
{
    query.exe user /server $server
}
else
{
    Write-Host "Invalid monitor option specified"
    Exit 999
}