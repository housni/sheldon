# Sheldon: The not-so-bashful Bash framework. Bazinga!

![Bazinga!](https://cdn.rawgit.com/housni/Sheldon/master/resources/logo/sheldon.svg)

## Introduction
As you can tell, I'm a fan of [The Big Bang Theory](https://en.wikipedia.org/wiki/The_Big_Bang_Theory).

I had some [Bash](https://en.wikipedia.org/wiki/Bash_(Unix_shell)) utility functions I had created over the years and I kept sourcing various files in order to use them. A few days ago, I decided to put them all together into an easily usable way. And so, Sheldon was born. BAZINGA!

After I started, I wanted to find out how far I could push Bash. Bash is really meant for simple scripting. It's not an OOP language. But, experimenting with it was fun and this is exactly that, an experiment. A lot of the things in this framework should really be done with a more suitable tool like Perl or Python.

A lot of the functions and coding style is deeply inspired by [li₃](https://github.com/UnionOfRAD/lithium) aka Lithium. PHP and Ruby have also influenced the syntax, somewhat. A developer familiar with these three is likely to find Sheldon easy to deal with...if only Leonard had such luck!


## Requirements
Linux or UNIX running Bash.
I haven't tested this on any version of Sh or on a version of Bash older than 4.3.
```
$ bash --version
GNU bash, version 4.3.30(1)-release (i686-pc-linux-gnu)
```
You could try this on a Mac but I have no idea if it will work.


## Usage
Sheldon only needs `meemaw.sh` to work. That's his bootstrap file.
I'll assume you have Sheldon installed at `/usr/lib/sheldon` and that `meemaw.sh` lives at `/usr/lib/sheldon/meemaw.sh`.

You need to make it executable:
```
$ chmod +x /usr/lib/sheldon/meemaw.sh
```

### Basic
Suppose you create the script `/usr/bin/basic.sh`, you could use it like this:
```shell
# Bootstrap Sheldon.
. ./lib/sheldon/meemaw.sh

# Set strict mode.
# Optional but highly recommend.
Sheldon.Core.Sheldon.strict

# Load the String file.
# This file would live at /usr/lib/sheldon/util/String.sh
use Sheldon.Util.String as String

# Declare your variables to avoid bugs.
declare CAST

# $String.join will assign the result to 'CAST'.
# To understand this, read the 'Returning Values' for 'Functions' documentation:
# https://github.com/housni/Sheldon/wiki/Functions#returning-values
$String.join =CAST '/' $@

echo "Awesome cast: ${CAST}"

# Always exit with an appropriate exit code.
exit 0
```

If you ran the script like:
```shell
$ /usr/bin/basic.sh Raj Howard Sheldon Leonard
```

The output would read:
```shell
Awesome cast: Raj/Howard/Sheldon/Leonard
```



### Advanced
Suppose you create the script `/usr/bin/setup.sh`, you could use it like this:
```shell
# Uncomment this if you need to debug.
# set -x

# Bootstrap Sheldon.
. ./lib/sheldon/meemaw.sh

# Set strict mode. Although optional, I highly recommend scripting with this.
Sheldon.Core.Sheldon.strict

# Load (source) the String file.
# This file would live at /usr/lib/sheldon/util/String.sh
use Sheldon.Util.String as String

# It's good practice to declare your variables.
declare DIR
declare STRING
declare -A DATA

STRING='/var/www/src/{:client}/{:domain}'
DATA=( ['client']="$1" ['domain']="$2" )

# $String.insert will assign the result to 'DIR'.
# Look at the function in /usr/lib/sheldon/util/String.sh to understand this.
$String.insert =DIR "${STRING}" DATA
echo "Setting up structure for '${DIR}'"

mkdir -p ${DIR}/{backup,bin,docs,src,resources,tests,tmp,var/logs}

# Always exit with an appropriate exit code.
exit 0
```

If you ran the script like:
```shell
$ /usr/bin/setup.sh "Housni" "housni.org"
```

It will create a structure like the following inside `/var/www/src`:
```
└── Housni
    └── housni.org
        ├── backup
        ├── bin
        ├── docs
        ├── resources
        ├── src
        ├── tests
        ├── tmp
        └── var
            └── logs
```

Right now, I only have a few basic functions like the String function.
This is actually more powerful when you have to do large setups and repetitive things with Bash.

This example uses the Registry pattern:
```shell
# Uncomment this if you need to debug.
# set -x

# Bootstrap Sheldon.
. ./lib/sheldon/meemaw.sh

# Set strict mode. Although optional, I highly recommend scripting with this.
Sheldon.Core.Sheldon.strict

use Sheldon.Storage.Registry as Registry

declare WHO
declare LOVES

$Registry.set 'who' 'Sheldon'
$Registry.set 'loves' 'Meemaw'

# The result is stored in the upper case version of the key.
$Registry.get 'who'
$Registry.get 'loves'

echo "${WHO} loves his ${LOVES}"

# Always exit with an appropriate exit code.
exit 0
```

The above would yield:
```
Sheldon loves his Meemaw
```


## Contributing
A lot of things can go wrong with big bash libraries unless you code using good practices like:
* Declaring all variables before use using `declare`.
* Using `local` for variables within functions in order to limit scope.
* Using quotes and braces for variables where necessary.
* Being consistent in every piece of code you write.
* Follow the [Google Shell Style Guide](https://google-styleguide.googlecode.com/svn/trunk/shell.xml).

In other words, code like Sheldon Lee Cooper would ;)


## License
The BSD License: [http://opensource.org/licenses/bsd-license.php](http://opensource.org/licenses/bsd-license.php)