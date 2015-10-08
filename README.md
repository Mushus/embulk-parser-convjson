# json parser plugin for Embulk

This is convinience JSON parser for Embulk.

## Overview

* **Plugin type**: parser
* **Guess supported**: no

## Configuration

- **foreach**: ruby expression to make multiple record (string, default: nil)
- **exclude**: ruby expression to exclude record (string, default: "false")
- **shema**: record shema (array, default: nil)

## Example

config.yml:
```yaml
in:
  type: file
  path_prefix: C:\develop\project\diw\embulk\sample.json
  parser:
    type: convjson
    foreach: json
    exclude: "key == 'junk_data'"
    schema:
      - {name: key, type: string, exp: "key"}
      - {name: id, type: long, exp: "index"}
      - {name: message, type: string, exp: "value['message']"}
      - {name: add, type: double, exp: "value['int'] + value['float']"}
      - {name: now, type: string, exp: "Time.now"}
      - {name: time, type : timestamp, exp: "value['date']", format: "%Y/%m/%d"}
```

sample.json:
```json
{
    "junk_data": {
        "message": "I'm not need."
    },
    "a":{
        "message": "hello world!",
        "int": 1,
        "float": 0.1,
        "child": {
            "message": "I'm child."
        },
        "date": "2015/01/01"
    },
    "b":{
        "message": "hello world!",
        "int": 1,
        "float": 0.1,
        "child": {
            "message": "I'm child."
        },
        "date": "2015/10/10"
    }
}
```

(If guess supported) you don't have to write `parser:` section in the configuration file. After writing `in:` section, you can let embulk guess `parser:` section using this command:

TODO: registing gem dir

```
$ embulk gem install embulk-parser-singlejson
$ embulk guess -g singlejson config.yml -o guessed.yml
```

result:
```
+------------+---------+----------------+------------+---------------------------+-------------------------+
| key:string | id:long | message:string | add:double |                now:string |          time:timestamp |
+------------+---------+----------------+------------+---------------------------+-------------------------+
|          a |       1 |   hello world! |        1.1 | 2015-10-08 14:57:06 +0900 | 2014-12-31 15:00:00 UTC |
|          b |       2 |   hello world! |        1.1 | 2015-10-08 14:57:06 +0900 | 2015-10-09 15:00:00 UTC |
+------------+---------+----------------+------------+---------------------------+-------------------------+
```

## Build

```
$ rake
```
