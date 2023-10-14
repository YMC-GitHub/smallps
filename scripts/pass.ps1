
<#
.SYNOPSIS
    encode text data
.DESCRIPTION
    This PowerShell script encode string for your password or something.
.EXAMPLE
    PS> ./pass.ps1 -sslf "name:anytexthere,email:anytexthere,site:anytexthere;method:sha512,cut:8,end:!,upper-start:3"
.LINK
    https://github.com/ymc-github/smallps
.NOTES
    Author: yemiancheng | License: MIT
#>

# bind cli args to script
[CmdletBinding()]
param ( 
    [Parameter(Position = 0)][string]$cmd = "add",
    $text="",
    $hash="",
    $slkv="",
    $sslf="",
    $save="",
    $file=""
)


#http://jongurgul.com/blog/get-stringhash-get-filehash/
function Get-StringHash([String] $String,$HashName = "MD5")
{
$StringBuilder = New-Object System.Text.StringBuilder
[System.Security.Cryptography.HashAlgorithm]::Create($HashName).ComputeHash([System.Text.Encoding]::UTF8.GetBytes($String))|%{
[Void]$StringBuilder.Append($_.ToString("x2"))
}
$StringBuilder.ToString()
}


# str_arr
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


function string_is_empty() {
    param
    (
        [Parameter(Position = 0)][string]$value = ""
    )
    if ([string]::IsNullOrWhiteSpace($value)) {
        return $True
    }
    return $False
}
function string_get() {
    param
    (
        [Parameter(Position = 0)][string]$value = "",
        [Parameter(Position = 1)][string]$defautv = ""
    )
    $res = If (string_is_empty $value) {$defautv} Else {$value}
    return $res
}
# string_get $srcdir "D:\code\python\comfyui"




# multi line text
function mlt_del_emptyline() {
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
# function mlt_del_comment() {
#     param(
#         [Parameter(Position = 0)][array] $value
#     )
#     $dels = $value
#     [System.Collections.ArrayList]$array = $dels
#     foreach ($item in $dels) {
#         if ($item.trim() -eq "") {
#             $array.Remove($item)
#         }
#     }
#     return $array
# }

function mlt_load_file() {
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
function mlt_get_lastline() {
    param(
        [Parameter(Position = 0)][array] $value
    )
    [System.Collections.ArrayList]$array = $value
    return $array[-1]
}





# string_line_keyval
function slkv_get() {
    param(
        [Parameter(Position = 0)][string] $value = "",
        [Parameter(Position = 1)][string] $slkv = '',
        [Parameter(Position = 2)][bool] $caseSensitive=$False
    )
    $res = ''
    # with static order
    $list = $slkv -split ","
    for ($i = 0; $i -le ($list.length - 1); $i += 1) {
        $kv = $list[$i].trim()
        $kvarr = $kv -split ":"
        $k=$kvarr[0].trim()
        $ki=$value.trim()
        if($caseSensitive -eq $false){
            $k=$k.ToUpper()
            $ki=$ki.ToUpper()
        }
        if ($k -eq $ki) {
            $res = $kvarr[1].trim()
            Break
        }
    }
    return $res
}

# slkv_get "cut" $slkv


# safe string line format
function sslf_get_head() {
    param(
        [Parameter(Position = 0)][string] $data = ""
    )
    $head = ''
    $head=$data -replace ";.*",""
    return $head
}
function sslf_get_tail() {
    param(
        [Parameter(Position = 0)][string] $data = ""
    )
    $head = ''
    $head=$data  -replace ".*;",""
    return $head
}

function sslf_load_file() {
    param(
        [Parameter(Position = 0)][string] $loc = "",
        [Parameter(Position = 1)][string] $txt = ""
    )
    $res=mlt_load_file "$file" "$txt"
    $res = $res -replace "^ *#.*", ""
    $res = $res -replace "^\<!--.*--\>", ""
    $res = mlt_del_emptyline $res
    return $res
}



# string hash text
function shtkv_get_pure_v() {
    param(
        [Parameter(Position = 0)][string] $data = ""
    )
    $value = ''
    $value=$data -replace "name:","" -replace "email:","" -replace "site:","" -replace ",$",""
    return $value
}



# path
function path_get_name() {
    param
    (
        [Parameter(Position = 0)][string]$value = ""
    )
    # $tmpv=$value -replace "\\","/"
    $tmpv = path_normalize $value "\\" "/"
    return $tmpv -replace ".*\/", ""
}

function path_get_dirs() {
    param
    (
        [Parameter(Position = 0)][string]$value = ""
    )
    $name = path_get_name $value
    return $value -replace "$name$", ""
}

function path_normalize() {
    param
    (
        [Parameter(Position = 0)][string]$value = "",
        [Parameter(Position = 1)][string]$search = "\\",
        [Parameter(Position = 2)][string]$replace = "/"

    )
    return $value -replace $search, $replace
}
# sam:path_normalize  "scripts/$name/readme.md" 
# sam:path_normalize  "scripts/$name/readme.md" "\/" "\"


function os_path_exsit() {
    param(
        [Parameter(Position = 0)][string] $loc = ""
    )
    # test-path $src
    
    if (-not(string_is_empty $loc) -and (test-path $loc)) {
        return $True
    }
    return $False
}
function os_path_make() {
    param(
        [Parameter(Position = 0)][string] $loc = ""
    )
    # test-path $src
    if(-not(string_is_empty $loc) -and (-not(test-path $loc))){
        $null=mkdir -p $loc -ErrorAction SilentlyContinue
    }
}

function add_password_to_file(){
    param(
        [Parameter(Position = 0)][string] $loc = "",
        [Parameter(Position = 1)][string] $pas = ""
    )
    if(os_path_exsit $loc){
        $txt=get-content -path $loc
        # $txt="$txt`n$pas"
        $txtarr=$txt -split "`n"
        # $txtarr.add($pas)
        $txtarr += $pas
        $txt=$txtarr -join "`n"
        # $txt
        set-content -path $loc -value $txt
    }
}

function html_comment_wrap(){
    param(
        [Parameter(Position = 0)][string] $value = ""
    )
    return "<!-- $value -->"
}
function html_comment_unwrap(){
    param(
        [Parameter(Position = 0)][string] $value = ""
    )
    return $value -replace "^<!--","" -replace "^-->$",""
}





$cmds = $cmd -split ","
# $nss = $ns -split ","

if(oneof "-h,--help,help" $cmds){
    $usage=@"
pass.ps1 v1.0.0 - encode string for your password or something copyright zero.com
Usage: .\pass.ps1 <cmd> <option>

Cmd:
version -- get this program version
help -- get this program help usage

Option:
-sslf [ssltext] -- optional,custom how to encode your text
-file [location] -- optional,input -sslf value from file
-save [location] -- optional,enable and save result to file


ssltext: (ps: name:anytexthere,email:anytexthere,site:anytexthere;method:sha512,cut:8,end:!,upper-start:3)
name:anytexthere,email:anytexthere,site:anytexthere -- requires, the text to be encode, your can set any text here, not must to be name,email,key
method:sha512 -- optional, use the method to make hash, default is sha512
cut:8 -- optional, cut the hash from 0 to  the length, default is 8
end:! --  optional, end the hash with the value,default is "!"
upper-start:3 -- optional, upper case from 0 to  the length, default is 3

Demo:
.\pass.ps1 version
.\pass.ps1 help
.\pass.ps1 -sslf "name:anytexthere,email:anytexthere,site:anytexthere;method:sha512,cut:8,end:!,upper-start:3"
.\pass.ps1 -file secret\password.md -save .\secret\password.md

"@
    "$usage"
    exit 
}

if(oneof "-v,--version,version" $cmds){
    "pass.ps1 v1.0.0"
    exit
}


$txt_samples="any text here!you can oranize it by yourself!"
$slkv_txt="$txt_samples;method:sha512,cut:8,end:!,upper-start:3"
# get from cli args -text or -hash
$slkv_txt=string_get $text $slkv_txt
# $slkv_txt=string_get $hash $slkv_txt
# get from cli args -slkv
$slkv_txt=string_get $slkv $slkv_txt
# # get from cli args -sslf
$slkv_txt=string_get $sslf $slkv_txt

# get from cli args -file
if($file){
    $cnftxt=sslf_load_file "$file" $slkv_txt
    # $cnftxt
    $cnftxtlastline=mlt_get_lastline $cnftxt
    # "[file.lastline] " + $cnftxtlastline
    $slkv_txt=string_get $cnftxtlastline $slkv_txt
}


$sslf_head=sslf_get_head $slkv_txt
# $sslf_head

$sslf_tail=sslf_get_tail $slkv_txt
# $sslf_tail

$sslf_head_pure_v=shtkv_get_pure_v $sslf_head
# $sslf_head_pure_v

# slkv_get "name" $slkv_txt
# slkv_get "email" $slkv_txt
# slkv_get "site" $slkv_txt
# slkv_get "cut" $slkv_txt
# slkv_get "end" $slkv_txt
# slkv_get "upper-start" $slkv_txt

$method=slkv_get "method" $sslf_tail
$method=string_get $method "SHA512"
$stringhash_text=string_get $sslf_head_pure_v $sslf_head
$hash=Get-StringHash "$stringhash_text" "$method"



# cut:8
$cutlength=slkv_get "cut" $sslf_tail
$cutlength=string_get $cutlength "8"
$hash8=$hash.Substring(0,[int]$cutlength)

# $hash8=$hash.Substring(0,8)
# [ps1-str-substring](https://lazyadmin.nl/powershell/substring/)

# end:!
$endstring=slkv_get "end" $sslf_tail
$endstring=string_get $endstring "!"
if($endstring){
    $endstringonlyone=$endstring.Substring(0,1)
    $hash8g=$hash8.Substring(0,$hash8.length-1)
    $hash8g=$hash8g+$endstringonlyone
    $hash8=$hash8g
}
# $hash8g

# upper-start:3
$uppslength=slkv_get "upper-start" $sslf_tail
$uppslength=string_get $uppslength "3"
if($uppslength){
    $hash8b3=$hash8g.Substring(0,[int]$uppslength).ToUpper()
    $hash8se=$hash8g.Substring([int]$uppslength)
    $hash8=$hash8b3 + $hash8se
}
# $hash8
# [ps1 str to upper](https://devblogs.microsoft.com/scripting/powertip-convert-to-upper-case-with-powershell/)


# info human readable hash
$name=slkv_get "name" $sslf_head
$site=slkv_get "site" $sslf_head
$res=$name,$hash8,$site -join ","
$res
# "[pas.human.readable] " + $res

$res=html_comment_wrap $res
# $txt=$sslf_head,$res -join "`n"
# $txt=$sslf,$res -join "`n"
$txt=$slkv_txt,$res -join "`n"
# $txt
add_password_to_file "$save" "$txt"

