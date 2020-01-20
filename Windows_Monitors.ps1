param
(
    [String]$server,     #Server name
    [String]$load,       #CPU usage,
    [String]$drive,      #drive letter to check space of
    [String]$freespace,  #amount of free space desired (in percent)
    [String]$amount,     #amount of free ram desired
    [String]$servicename,#name of service to check the status of, wildcards supported
    [String]$monitor,    #Which monitor to use
    [String]$process,    #Name of process you want to monitor
    [String]$port        #Port you want to monitor
)

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
        Write-Host $_.LoadPercentage "`r"
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
    if ((Get-WmiObject Win32_PerfRawData_PerfOS_Memory -ComputerName "$server").AvailableMbytes -lt $amount)
    {
        write-host "low memory"
        Exit 100
    }
}
elseif($monitor -eq "service")
{
    #Will fail if the entered service is stopped
    $services = @((Get-Service -ComputerName "$server" -Name "$servicename" | Where-Object {$_.status -eq "stopped"}).DisplayName)

    If($services[0])
    {
        Write-Host $services
        Exit 100
    }
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

    <#
        $Timeout = 1000
        $Ping = New-Object System.Net.NetworkInformation.Ping
        $Response = $Ping.Send("ec2-34-213-163-167.us-west-2.compute.amazonaws.com",$Timeout)
        $Response.Status 
    #>
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
else
{
    Write-Host "Invalid monitor option specified"
    Exit 999
}