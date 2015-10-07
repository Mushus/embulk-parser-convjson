# Singlejson parser plugin for Embulk

TODO: Write short description here and embulk-parser-singlejson.gemspec file.

## Overview

* **Plugin type**: parser
* **Guess supported**: no

## Configuration

- **shema**: description (array, required)

## Example

```yaml
in:
  type: any file input plugin type
  parser:
    type: singlejson
    shema: example1
```

(If guess supported) you don't have to write `parser:` section in the configuration file. After writing `in:` section, you can let embulk guess `parser:` section using this command:

```
$ embulk gem install embulk-parser-singlejson
$ embulk guess -g singlejson config.yml -o guessed.yml
```

## Build

```
$ rake
```
