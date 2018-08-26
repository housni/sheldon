


# Sheldon
Sheldon is a Bash 4.3+ library that is intuitive and easy to use, developed using Test Driven Development (TDD).

- Bash 4.3+
- Uses Test Driven Development
- Intuitive
- Easy

[![Build Status](https://travis-ci.org/housni/Sheldon.svg?branch=master&style=flat-square)](https://travis-ci.org/housni/Sheldon)  [![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](http://makeapullrequest.com) [![MIT Licensed](https://img.shields.io/badge/license-MIT-blue.svg?style=flat-square)](https://github.com/housni/Sheldon/blob/master/LICENSE)

# Table of Contents
- [Overview](#overview)
    - [Why Sheldon?](#why-sheldon)
- [Install](#install)
    - [Requirements](#requirements)
    - [Install with GNU Make (recommended)](#install-with-gnu-make-recommended)
    - [Install from Source](#install-from-ource)
- [Getting Started](#getting-started)
    - [Basic](#basic)
    - [Advanced](#advanced)
- [Manual](#manual)
- [Examples](#examples)
- [Special Variables](#special-variables)
- [Features](#features)
- [Philosophy](#philosophy)
- [Developer](#developer)
    - [Running Tests](#running-tests)
    - [Help](#help)
- [Uninstall](#uninstall)
- [License](#license)

# Overview
[(Back to top)](#table-of-contents) | [Why Sheldon?](#why-sheldon)

Sheldon is named after Sheldon Cooper in The Big Bang Theory :)

As a DevOps Engineer, I had a many [Bash](https://en.wikipedia.org/wiki/Bash_(Unix_shell)) utility functions that I had created over the years. I kept sourcing the various files in order to use them. I then decided to put them all together into an easily usable way, and so, Sheldon was born. BAZINGA!

Sheldon is a combination of Bash functions that do a lot of the heavy lifting for common scripting tasks. The functions are implemented in pure Bash, where possible, without external dependencies. This ensures that if a dependency is missing in an environment, the code won't fail. While Bash might be relatively slow in execution, it's certainly going to run faster than if you had to first install a dependency and then use it.

For example, if you wanted to manipulate JSON objects during your CI build process, you might use [`jq`](https://github.com/stedolan/jq/), which is a fantastic tool. However, this usually involves installing `jq` and then using it. Sheldon can work with simple JSON objects which means, you wouldn't have any dependencies and you can just use Sheldon to process your simple JSON objects. An example of this can be seen at [examples/resolve_apache_conf/resolve_apache_conf.sh](examples/resolve_apache_conf/resolve_apache_conf.sh).

## Why Sheldon?
[(Back to top)](#table-of-contents) | [(Overview)](#overview)

Many Bash libraries and frameworks out there require you to learn a few specific conventions in order to use them. You usually can't install the framework and start coding without first getting familiar with a few of those conventions.

Sheldon is a simple, light-weight fella. You'll feel like you're using regular Bash except you'll be writing fewer lines of code because a lot of common complex tasks have already been implemented in this library with a lot more to come! All this makes Sheldon easy to use even for someone who only knows the basics of Bash.

# Install
[(Back to top)](#table-of-contents) | [Requirements](#requirements) | [Install with GNU Make (recommended)](#install-with-gnu-make-recommended) | [Install from Source](#install-from-ource)

There are various ways to install Sheldon. [Install with GNU Make (recommended)](#install-with-gnu-make-recommended) is the recommended *and* easiest way. All the installation process does is, it copies the Sheldon library files to `/usr/local`, by default.

## Requirements
[(Back to top)](#table-of-contents) | [Install](#install)
- Bash 4.3+
- GNU Make (preferable)
- gawk (only if you plan to use the `Sheldon.Transform.JSON.loads()` function)

**Why Bash version 4.3?** I wanted Sheldon to use associative arrays and the only way to do that without using [`eval`](http://wiki.bash-hackers.org/commands/builtin/eval), which I wanted to avoid as much as possible, is by passing arrays by reference which was a feature only introduced in version 4.3.

## Install with GNU Make (recommended)
[(Back to top)](#table-of-contents) | [Install](#install)

1. Run linters and unit tests against the code (optional but recommended)
    ```bash
    $ make check
    ```
2. Install to `/usr/local`, by default
    ```bash
    $ make install
    ```
3. [Start using Sheldon](#basic)

## Install from Source
[(Back to top)](#table-of-contents) | [Install](#install)

1. Clone the repo
    ```bash
    $ git clone git@github.com:housni/sheldon.git
    ```
2. Copy it to `/usr/local/lib`
    ```bash
    $ sudo cp -r ./lib/sheldon /usr/local/lib
    ```
3. [Start using Sheldon](#basic)

# Getting Started
[(Back to top)](#table-of-contents)

In order to start using Sheldon, you'll need to:
1. bootstrap
2. turn on "strict mode"

Bootstrapping is done by sourcing `/usr/local/lib/sheldon/bootstrap.sh` in your shell script and then, optionally but preferably, enabling "strict mode":
```bash
#!/usr/bin/env bash

# Sourcing Sheldons bootstrap file.
. /usr/local/lib/sheldon/bootstrap.sh

# Enable strict mode to prevent lazy code.
Sheldon.Core.Sheldon.strict

# Start using Sheldon here.
```
Strict mode is not required but it's very highly recommended. It will essentially cause Bash to warn you of things that could lead to potential bugs in your code like undefined variables. It will also cause your script to terminate in the case of a command exiting with a non-zero exit status.

## Basic
[(Back to top)](#table-of-contents) | [(Getting Started)](#getting-started)

In `basic.sh` below,, the [`String.join()`](lib/sheldon/util/String.sh) function is used to combine space delimited text using a forward slash.

```bash  
#!/usr/bin/env bash

# Sourcing Sheldons bootstrap file.
. /usr/local/lib/sheldon/bootstrap.sh

# Enable strict mode to prevent lazy code.
Sheldon.Core.Sheldon.strict

# Import Sheldons "String" module
import Sheldon.Util.String as String

declare path
declare -i length

# Join arguments passed into this script with '/'
path=$($String.join '/' $@)

# Get length of $path
length=$($String.length "$path")

echo "Path is '$path' with length '$length'."

exit 0
```

Output:
```bash
$ ./basic.sh foo bar baz
Path is 'foo/bar/baz' with length '11'.
```

## Advanced
[(Back to top)](#table-of-contents)

The [`examples/resolve_apache_conf/resolve_apache_conf.sh`](examples/resolve_apache_conf/resolve_apache_conf.sh) script is a well commented example tht shows a relatively advanced use of Sheldon.

# Manual
[(Back to top)](#table-of-contents)

See [Sheldon > Projects > Documentation](https://github.com/housni/sheldon/projects/2)

# Examples
[(Back to top)](#table-of-contents)

Some useful examples:
- [Default Function Options](examples)
- [Resolve Apache Configs](examples)

# Special Variables
[(Back to top)](#table-of-contents)

`__SHELDON` is a special variable and is used internally so it should not be overwritten.

# Features
[(Back to top)](#table-of-contents)

## Simple JSON support
[(Back to top)](#table-of-contents)

Using its [JSON module](lib/sheldon/transform/JSON.sh), Sheldon can convert a Bash associative array into a simple JSON object using the `Sheldon.Transform.JSON.dumps()` function. Conversely, Sheldon can also convert a simple JSON object into a Bash associative array using the `Sheldon.Transform.JSON.loads()` function.

## Own test framework
[(Back to top)](#table-of-contents)

Sheldon needed a simple yet effective way to run tests against the code. Instead of using a full-blown test framework, I put together the [TestFrameworkInAFile.sh script](lib/sheldon/test/TestFrameworkInAFile.sh) which is quite easy to use and lets you run `setUp()` and `tearDown()` before and after tests.

## Custom checker for naming convention
[(Back to top)](#table-of-contents)

Sheldon has a specific [naming convention](naming-convention). As human beings, we will make mistakes which is why I wrote `bin/check-convention` which runs on `make check.lint.sheldon` (among other events such as git pre-commit hooks, [when installed](setting-up-dev)). This ensures that all our code follows convention and nothing breaks.

## Intuitive interface
[(Back to top)](#table-of-contents)

Sheldon was written while referring to the Python 3 manual. As such, you may find that a lot of the functions in Sheldon are similar to Python functions, making it easier for Python developers to understand what some functions do.

## Easy to use
[(Back to top)](#table-of-contents)

Sheldon uses the same 'ol Bash syntax meaning you don't have to learn a new syntax to use it. Bash is not meant to use OOP and so I didn't implement Sheldon using OOP meaning we can stick to the Bash syntax we are all used to when working with Sheldon.

# Philosophy
[(Back to top)](#table-of-contents)

## Avoid `eval`, where possible
[(Back to top)](#table-of-contents)

The dangers of the `eval` builtin are well known. With that in mind, I avoided using `eval` as much as possible. Right now, there are only two instances of `eval` used in Sheldon. You can actually check this yourself by running:
```bash
$ make stats
```
 The above actually triggers [`bin/check-evals`](bin/check-evals) which yields the following:
```bash
$ make stats

Sheldon is working. Please wait...

#############
TARGET: stats
#############
All occurrences of 'eval' in code: 
/sheldon/lib/sheldon/bootstrap.sh:209:    eval "$3"="$1"
/sheldon/lib/sheldon/test/TestFrameworkInAFile.sh:45:    eval "$line"
```
As you can see, `eval` is only used in bootstrap.sh on line 209 (which is inside the `import()` function) and `TestFrameworkInAFile.sh` which uses `eval` in order to execute test cases.

## The documentation is as important as the code.
[(Back to top)](#table-of-contents)

Nobody's going to use something if they don't know how to use it. That's why I have [this project](https://github.com/housni/sheldon/projects/2).

**TODO:** The documentation is forthcoming. For now, you may have to take a look at a few tests and refer to the source code itself which is reasonably well commented.

## Where possible, use pure bash.
[(Back to top)](#table-of-contents)

In most cases, we are discouraged from installing tools/dependencies on servers where possible. We can almost always do what we need to do, in most cases, using Bash. So, where possible, functions are using pure Bash instead of external tools.

# Developer
[(Back to top)](#table-of-contents)

If you want to add code to the Sheldon library, please submit a pull request! In order to start developing, there are some things to be aware of. Read on.

## Prerequisites
- Bash 4.3+
- build-essential (for the `make` utility used for linting, testing, installing, etc).
- Docker (for linting and testing).

**NOTE:** In order to lint/test our code in a specific version of Bash, I use Docker.

## Setting up dev

You must first clone the repository and install the `git` pre-commit hooks:
1. Clone the repository
    ```bash
    $ git clone https://github.com/housni/sheldon
    ```
2. `cd` into the directory
    ```bash
    $ cd sheldon
    ```
3. Install `git` pre-commit hooks
    ```bash
    $ make hooks
    ```
The `make hooks` command places `git` hooks in the appropriate directories. These hooks do things like lint the code and run unit tests when a commit is made to the repository.

## Naming Convention
In Sheldon, arrays are passed into functions by reference. When a variable is passed by reference, the corresponding variable name, inside the function, must be prefixed with `__shld_` to avoid a "circular name reference" error in Bash.

For example:

### Bad
Contents of bad.sh:
```bash
#!/usr/bin/env bash

. /usr/local/lib/sheldon/bootstrap.sh
Sheldon.Core.Sheldon.strict

output_vars() {
  local -n foo
  foo="$1"
  echo "${foo[@]}"
}

declare -a foo
foo=( first second third )
output_vars foo
```

Output:
```bash
$ ./bad.sh
./bad.sh: line 9: warning: foo: circular name reference
```
The error is caused by using a variable, `foo`, with the same name inside and outside the function when the variable is passed by reference (via `local -n ...`).

### Good
Contents of good.sh:
```bash
#!/usr/bin/env bash

. /usr/local/lib/sheldon/bootstrap.sh
Sheldon.Core.Sheldon.strict

output_vars() {
  local -n __shld_foo
  __shld_foo="$1"
  echo "${__shld_foo[@]}"
}

declare -a foo
foo=( first second third )
output_vars foo
```

Output:
```bash
$ ./good.sh
first second third
```
The above will not show us an error because `foo` inside the function is prefixed with `__shld_` so that it ends up being `__shld_foo` which makes it easier to avoid variable name collision.

### Style guide
[(Back to top)](#table-of-contents)

All shell scripts must follow the Google Shell Style Guide: https://google.github.io/styleguide/shell.xml

## Running Tests
[(Back to top)](#table-of-contents)


The common misconception about Bash is that it's difficult to code and test for it because of how "error prone" it is.
As with any language, Bash is actually very easy to code if you know how to do it properly. explain `set -e`, `set -o pipefail` and `set -u`.


Tests are very important when developing Sheldon.
In order to run tests, use `make`:

    $ make test

## Help
[(Back to top)](#table-of-contents)

1. Lists available targets in Makefile.

    $ make help
 
2. Lists detailed help for the 'check.lint.shellcheck' target.

    $ make HELP_TARGET=check.test.unit help


# Uninstall
[(Back to top)](#table-of-contents)

    $ make uninstall

# License
[(Back to top)](#table-of-contents)

Sheldon is [MIT licensed](./LICENSE.txt).