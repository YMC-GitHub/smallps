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


## Demo to use tiny programs

- [x] download pass.ps1 from github repo
```bash
curl -sfLO https://ghproxy.com/https://raw.githubusercontent.com/ymc-github/smallps/main/dist/pass.ps1
```


- [x] custom how to encode your text
```powershell
$ssll="your text data;method:sha512,cut:8,end:!,upper-start:3"
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
```

- [x] encode your text from input file and save to file (use -sslf from -file)
```powershell
.\pass.ps1 -file secret\password.md -save .\secret\password.md
```

## Plans
- build powershell script from source dir (ps: src) to outdir (ps:dist)