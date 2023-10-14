<#
.SYNOPSIS
    get env path or add value to env path or del in it
.DESCRIPTION
    This PowerShell script get env path or add value to env path or del in it.
.EXAMPLE
    PS> ./list-user-groups.ps1
.LINK
    https://github.com/ymc-github/smallps
.NOTES
    Author: yemiancheng | License: MIT
#>

[CmdletBinding()]
param ( 
    [Parameter(Position = 0)][string]$cmd = "add",
    $value = "",
    [boolean]
    $setenv = $True,
    $isAdmin = $False,
    $envpath = $True,
    $file = "env.path.tmp.md",
    $savefile = $False,
    $envkey = "",
    $ns = 'env.path'
)
# Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force

function add_envp() {
    param($val = "", $isAdmin = $True)

    if ([string]::IsNullOrWhiteSpace($val)) {
        return 
    }
    $oldPath = [Environment]::GetEnvironmentVariable('Path', [EnvironmentVariableTarget]::Machine)
    if ($oldPath.Split(';') -inotcontains $val) { 
        if ($isAdmin) {
            [Environment]::SetEnvironmentVariable('Path', $("{0};$val" -f $oldPath), [EnvironmentVariableTarget]::Machine)
        }
        else {
            [Environment]::SetEnvironmentVariable('Path', $("{0};$val" -f $oldPath), [EnvironmentVariableTarget]::User)
        }
    }
}
# sam: add_envp -val "$env:SCOOP" -isAdmin $True

function set_envp() {
    param($val = "", $isAdmin = $True)
    # set env.Path

    if ([string]::IsNullOrWhiteSpace($val)) {
        return 
    }
    if ($isAdmin) {
        [Environment]::SetEnvironmentVariable('Path', $val, [EnvironmentVariableTarget]::Machine)
    }
    else {
        [Environment]::SetEnvironmentVariable('Path', $val, [EnvironmentVariableTarget]::User)
    }
}

function get_envp() {
    param($key = "Path",$val = "", $isAdmin = $True)
    if ([string]::IsNullOrWhiteSpace($key)) {
        return 
    }
    if ($isAdmin) {
        $res = [Environment]::GetEnvironmentVariable($key, [EnvironmentVariableTarget]::Machine)
    }
    else {
        $res = [Environment]::GetEnvironmentVariable($key, [EnvironmentVariableTarget]::User)
    }
    return $res
}



function del_linev() {
    param(
        [Parameter(Position = 0)][string] $value = "",
        [Parameter(Position = 1)][array] $text,
        [Parameter(Position = 2)][string] $sc = ","

    )
    $dels = $value -split $sc
    [System.Collections.ArrayList]$array = $text
    foreach ($item in $dels) {
        $array.Remove($item)
        # $item
    }
    return $array
}
function add_linev() {
    param(
        [Parameter(Position = 0)][string] $value = "",
        [Parameter(Position = 1)][array] $text,
        [Parameter(Position = 2)][string] $sc = ","
    )
    $array = $text
    $ilist = $value -split $sc
    # with static order
    for ($i = 0; $i -le ($ilist.length - 1); $i += 1) {
        $hitem = $ilist[$i].trim()
        $canadd = $array.Contains("$hitem")
        if (!$canadd) {
            $array += @("$hitem")
        }
    }
    return $array
}


function out_step {
    param(
        $msg,
        [System.ConsoleColor]
        $foregroundColor,
        $backgroundColor,
        [int]
        $Padding = 0,
        [boolean]
        $newline = $False
    )
    IF ($foregroundColor -AND $backgroundColor) {
        Write-Host $msg.PadRight($Padding), "" -ForegroundColor:$foregroundColor -NoNewline -BackgroundColor:$backgroundColor

    }
    elseif ($foregroundColor) {
        Write-Host $msg.PadRight($Padding), "" -ForegroundColor:$foregroundColor -NoNewline
    }
    elseif ($backgroundColor) {
        Write-Host $msg.PadRight($Padding), ""  -NoNewline -BackgroundColor:$backgroundColor
    }
    else {
        Write-Host $msg.PadRight($Padding), ""  -NoNewline
    }
    if ($newline) {
        Write-Host "" 
    }
}
# sam:out_step -Msg "[step] dryrun" -ForegroundColor:Yellow
# sam:out_step -Msg "[ok]" -ForegroundColor:Green -Padding 50


function del_emptyline() {
    param(
        [Parameter(Position = 0)][array] $value
    )
    $dels = $value
    [System.Collections.ArrayList]$array = $dels
    foreach ($item in $dels) {
        if ($item.trim() -eq "") {
            $array.Remove($item)
        }
    }
    # $array
    return $array
}
function del_comment() {
    param(
        [Parameter(Position = 0)][array] $value
    )
    $dels = $value
    [System.Collections.ArrayList]$array = $dels
    foreach ($item in $dels) {
        if ($item.trim() -eq "") {
            $array.Remove($item)
        }
    }

    return $array
}

function load_text() {
    param(
        [Parameter(Position = 0)][string] $loc = "",
        [Parameter(Position = 1)][string] $txt = ""

    )
    $myres = $txt
    # get host file data
    if (Test-Path $loc) {
        $myres = Get-Content $loc 
    }
    return $myres
}

function load_data() {
    param(
        [Parameter(Position = 0)][string] $loc = "",
        [Parameter(Position = 1)][string] $txt = ""

    )
    $conf = load_text "$loc" $txt
    $conf = $conf -replace "^ *#.*", ""
    $conf = $conf -replace "^\<!--.*--\>", ""
    $conf = del_emptyline $conf
    $conf = del_comment $conf
    return $conf
}



function oneof() {
    param(
        [Parameter(Position = 0)][string] $value = "",
        [Parameter(Position = 1)][array] $list
    )
    # $canadd = $True
    $array = $list
    $ilist = $value -split ","

    $res = $False
    # with static order
    for ($i = 0; $i -le ($ilist.length - 1); $i += 1) {
        $hitem = $ilist[$i].trim()
        $canadd = $array.Contains("$hitem")
        if ($canadd) {
            $res = $true
            Break
        }
    }
    return $res
}


function everyof() {
    param(
        [Parameter(Position = 0)][string] $value = "",
        [Parameter(Position = 1)][array] $list
    )
    $array = $list
    $ilist = $value -split ","

    $res = $True
    # with static order
    for ($i = 0; $i -le ($ilist.length - 1); $i += 1) {
        $hitem = $ilist[$i].trim()
        $canadd = $array.Contains("$hitem")
        if ($canadd -eq $False) {
            $res = $false
            Break
        }
    }
    return $res
}

function envp_value_stringfy(){
    param(
        [Parameter(Position = 0)][array] $text 
    )
    [string]$res=$text -join ";"
    return $res
}

function envp_value_std(){
    param(
        [Parameter(Position = 0)][string] $text 
    )
    # [string]$res=$text -join ";"
    $res=$text -replace ";+",";"
    return $res
}

function envp_value_load_file(){
    param(
        [Parameter(Position = 0)][string] $value = "",
        [Parameter(Position = 1)][string] $file
    )
    $res=$value
    if(-not($value) -and $file){
        if(Test-Path $file){
            # $itext=Get-Content $file
            $itext=load_data $file
        }else{
            $itext=""
        }
        # $itext=$itext -replace "`r?`n",";"
        $itext=$itext.trim() -replace "$",";"
        # $itext
        [string]$filevalue=$itext
        $filevalue=$filevalue -replace "; +",";"
        $filevalue=$filevalue -replace ";+",";"
        $res=$filevalue
    }
    return $res
}


function log_envp(){
    param(
        [Parameter(Position = 0)][string] $value = ""
    )
    $res=envp_value_std $value
    out_step -Msg "[info] now env path" -newline $True
    $res
}


$cmds = $cmd -split ","
# $nss = $ns -split ","



# task:  -envkey "PYTORCH_CUDA_ALLOC_CONF" -value "max_split_size_mb:30" -setenv $True -envpath False



# handle  -file "xxx"
$value=envp_value_load_file $value $file

$envp_txt=get_envp
$envp_arr=$envp_txt -split ";"
# $envp_arr
# return

# del -value xx
if ($cmds.Contains("del") -AND $value) {
    out_step -Msg "[step] del env path" -newline $True
    $value
    $envp_arr=del_linev $value $envp_arr ";"
    # $envp_arr

    $envp_txt=envp_value_stringfy $envp_arr
    # $envp_txt

    log_envp $envp_txt

    # get_envp
}

# add -value xx
if ($cmds.Contains("add") -AND $value) {
    out_step -Msg "[step] add env path" -newline $True
    $value
    $envp_arr=add_linev $value $envp_arr ";"

    $envp_txt=envp_value_stringfy $envp_arr
    # $envp_txt

    log_envp $envp_txt
    # get_envp
}

# get
if ($cmds.Contains("get")) {
    $envp_txt=get_envp
    $envp_txt
}

# get -savefile "xxx"
# del -value xx -savefile "xxx"
# add -value xx -savefile "xxx"
if($savefile){
    out_step -Msg "[info] out: $file" -newline $True
    Set-Content -Path $file -Value $text 
}

