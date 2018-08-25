

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
- [Examples](#examples)
- [Special Variables](#special-variables)
- [Features](#features)
- [Philosophy](#philosophy)
- [Getting Help](#getting-help)
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

There are various ways to install Sheldon. [Install with GNU Make (recommended)](#install-with-gnu-make-recommended) is the recommended *and* easiest way.

All the installation process does is, it copies the Sheldon library files to `/usr/local`, by default.

## Requirements
[(Back to top)](#table-of-contents) | [Install](#install)
- Bash 4.3+
- GNU Make (preferable)

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
3. [Use Sheldon](#basic).

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

# Getting Started
[(Back to top)](#table-of-contents)

Briefly explain booststrap.sh is required and how good Strict Mode is.

## Basic
[(Back to top)](#table-of-contents)

Some kinda hello world?

## Advanced
[(Back to top)](#table-of-contents)

Use String.insert(), JSON.dumps(), JSON.loads() and an Array function.


# Examples
[(Back to top)](#table-of-contents)

- [Default Function Options](...)
- [Resolve Apache Configs](...)

# Special Variables
[(Back to top)](#table-of-contents)

Sheldon_tmp
Sheldon
SHELDON_LOG_LEVEL

Look in bootstrap.sh for more





# Features
[(Back to top)](#table-of-contents)

Intuitive interface
Easy to use
Has its own test framework
command_not_ found_handle
Custom checker for naming convention
Can handle simple JSON

# Philosophy
[(Back to top)](#table-of-contents)

Avoid eval, where possible (show output of `bin/check-evals`)
The documentation is as important as the code.
Where possible, use pure bash.
Use function names as similar to Python as possible.
Keep syntax pretty much close to Bash because nobody wants to learn a new syntax to use a Bash library, right?



# Getting Help
[(Back to top)](#table-of-contents)


# Developer
[(Back to top)](#table-of-contents)

## Prerequisites
- Bash 4.3+
- build-essential (for the `make` utility used for linting, testing, installing, etc).
- Docker (for linting and testing).

## Setting up dev

In order to start developing Sheldon, you must first clone the repo and install hooks:


    $ git clone https://github.com/housni/sheldon
    $ cd sheldon/
    $ make hooks # Installs git hooks.


The `make hooks` command places Git hooks in the appropriate directories. These hooks do things like lint the code and run unit tests when a commit is made to the repo.


## Naming Convention
vars passed by reference must be prefixed with __shld_ to avoid a circular reference error in bash where the name of the variable outside the function is the same as the one inside like:

### BAD
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


### GOOD
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

### Style guide
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