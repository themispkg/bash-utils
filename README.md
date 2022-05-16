# bash-utils - 1.0.0
useful bash scripts more like libraries.

# installation
```
git clone https://github.com/themispkg/bash-utils.git ; cd bash-utils && sudo make install
```

# Usage
```bash
> delphi --help

< The delphi library caller v1.0.0 - lazypwny751 2022
< there are 4 flags: version, path, help, <libname>
< 
< version: --version, -v;
< 	print's current delphi version.
< 
< path: --path, -p;
< 	print's delphi library directories.
<
< help: --help, -h;
< 	show's this screen.
< 
< <libname>: <libname 1> <libname 2> .. <libname N-1>;
< 	check and call the library, if not exist them abort the project.
< 	also '<libname>%<OPERATION><wantver>' mean <libname> the library
< 	to call you want, <OPERATION> the mathematical operator '>', '<' and '='
< 	the last thing <wantwer> is version to you want to call.
< 
```

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please test with shellcheck before open pull request.

## License
[GPL3](https://choosealicense.com/licenses/gpl-3.0/)
