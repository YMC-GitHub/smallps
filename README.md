# smallps

tiny programs in powershell .

## Author

name|email|desciption
:--|:--|:--
yemiancheng|<ymc.github@gmail.com>|code maintainers|

## License

GPL

## List tiny programs in dist

- pass.ps1 -- encode string for your password or something.
- edit-env-path.ps1 -- get env path or add value to env path or del in it
- edit-env.ps1 -- get env value or add value to env or del it

## Demo to use tiny programs

- [x] download pass.ps1 from github repo (bash)
```bash
curl -sfLO https://ghproxy.com/https://raw.githubusercontent.com/ymc-github/smallps/main/dist/pass.ps1
```

- [x] download pass.ps1 from github repo (powershell)
```powershell
# $url="www.baidu.com";irm $url -outfile '.\baidu.com';
$url="https://ghproxy.com/https://raw.githubusercontent.com/ymc-github/smallps/main/dist/pass.ps1";irm $url -outfile '.\pass.ps1';

# (New-Object System.Net.WebClient).DownloadFile($url, '.\pass.ps1')
# Invoke-WebRequest -OutFile '.\pass.ps1' -Uri $url -UseBasicParsing
```

- [x] get help usage for these program  pass.ps1
```powershell
.\pass.ps1 help
```

- [x] custom how to encode your text
```powershell
# name:anytexthere,email:anytexthere,site:anytexthere -- requires, the text to be encode, your can set any text here, not must to be name,email,key
# method:sha512 -- optional, use the method to make hash, default is sha512
# cut:8 -- optional, cut the hash from 0 to  the length, default is 8
# end:! --  optional, end the hash with the value,default is "!"
# upper-start:3 -- optional, upper case from 0 to  the length, default is 3

$ssll="name:anytexthere,email:anytexthere,site:anytexthere;method:sha512,cut:8,end:!,upper-start:3"
```

- [x] encode your text
```powershell
.\pass.ps1 -sslf "$ssll"
```

- [x] encode your text and save to file
```powershell
.\pass.ps1 -sslf "$ssll" -save .\secret\password.md
```


- [x] custom how to encode your text
```powershell
# add ssll in your input file 
# ps: .\secret\password.md
# ...
set-content -path .\secret\password.md -value "$ssll"
```

- [x] encode your text from input file and save to file (use -sslf from -file)
```powershell
.\pass.ps1 -file secret\password.md -save .\secret\password.md
```

- [x] download edit-env-path.ps1.ps1 from github repo (powershell)
```powershell
$url="https://ghproxy.com/https://raw.githubusercontent.com/ymc-github/smallps/main/dist/edit-env-path.ps1";irm $url -outfile '.\edit-env-path.ps1';
```

- [x] get env path or add value to env path or del in it
```powershell
$value="C:\Program Files (x86)\Internet Download Manager\"
.\edit-env-path.ps1 get
.\edit-env-path.ps1 del -value $value
.\edit-env-path.ps1 add -value $value
```


- [x] download edit-env.ps1.ps1 from github repo (powershell)
```powershell
$url="https://ghproxy.com/https://raw.githubusercontent.com/ymc-github/smallps/main/dist/edit-env.ps1";irm $url -outfile '.\edit-env.ps1';
```

- [x] get env value or add value to env or del it
```powershell
$envkey="PYTORCH_CUDA_ALLOC_CONF"
$value="max_split_size_mb:30"
.\edit-env.ps1 get -envkey $envkey
.\edit-env.ps1 set -envkey $envkey
.\edit-env.ps1 set -envkey $envkey -value $value

.\edit-env.ps1 get -envkey "PYTORCH_CUDA_ALLOC_CONF"
.\edit-env.ps1 set -envkey "PYTORCH_CUDA_ALLOC_CONF" -value "max_split_size_mb:30"
.\edit-env.ps1 set -envkey "PYTORCH_CUDA_ALLOC_CONF" -value "max_split_size_mb:128"
.\edit-env.ps1 set -envkey "PYTORCH_CUDA_ALLOC_CONF" -value ""
```


## Plans
- build powershell script from source dir (ps: src) to outdir (ps:dist)

## powershell trending in github

[trending powershell in github](https://github.com/trending/powershell)