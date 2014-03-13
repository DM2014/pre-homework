pre-homework
============

# How to run the code

## Prerequisite

* haskell-platform
* git (optional)

## Install

```shell
git clone git@github.com:DM2014/pre-homework.git
cd pre-homework
```

Or you can just download and unpack it.

```shell
cabal sandbox init
cabal install --only-dependencies
```

## build

```shell
cabal build
```
## Run

```shell
cat <dataset> | ./dist/build/pre-homework/pre-homework +RTS -K1000m -H500m -RTS
```
