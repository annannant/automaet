# Install Robot Framework via requirement.txt

#### Prepare Python and pip
>https://www.python.org/downloads/  
https://pip.pypa.io/en/stable/installing/ 
##### Prepare MySQL before install Robot Framework 
```sh
$ brew install mysql
```

##### Update File ~/.bash_profile
```sh
export PATH="/Library/Frameworks/Python.framework/Versions/2.7/bin:${PATH}"
export PATH=$PATH:/usr/local/mysql/bin
```

##### Start install Robot
go to path requirement.txt
```sh
$ sudo pip install -r requirement.txt
```

