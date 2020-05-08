# Windows system monitors with Powershell
This script shows basic examples of how to monitor Windows system resources using Powershell.

# Prerequisites
* Powershell v5.1

# Instructions
* <b>Server</b> - Name of the server you are targeting to monitor
* <b>Load</b> - CPU usage in %
* <b>Drive</b> - Drive you are checking for the amount of freespace
* <b>Freespace</b> - Freespace in % you want to monitor for
* <b>Amount</b> - Amount of free RAM in %
* <b>ServiceName</b> - Name of service to check the status of (wildcards supported)
* <b>Monitor</b> - Which type of monitor: cpu, disk, ram, service, ping, process, port, partition, resizepartition, loggedonuser
* <b>Process</b> - Name of process you want to monitor
* <b>Port</b> - Port you want to monitor
* <b>Disk</b> - Disk that you want information on or to resize
* <b>Partition</b> - Partition that you want to resize
* <b>Size</b> - Size in GB that you want to resize the partition too

Example:
```
powershell.exe -ExecutionPolicy Bypass -File "C:\Windows_Monitors.ps1" -server <myserver> -monitor <disk> -drive c -freespace 10
```

# Disclaimer
No Support and No Warranty are provided by SMA Technologies for this project and related material. The use of this project's files is on your own risk.

SMA Technologies assumes no liability for damage caused by the usage of any of the files offered here via this Github repository.

# License
Copyright 2020 SMA Technologies

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at [apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0)

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

# Contributing
We love contributions, please read our [Contribution Guide](CONTRIBUTING.md) to get started!

# Code of Conduct
[![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-v2.0%20adopted-ff69b4.svg)](code-of-conduct.md)
SMA Technologies has adopted the [Contributor Covenant](CODE_OF_CONDUCT.md) as its Code of Conduct, and we expect project participants to adhere to it. Please read the [full text](CODE_OF_CONDUCT.md) so that you can understand what actions will and will not be tolerated.
