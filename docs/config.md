# config

`config` is a command for managing environment's config vars.
config vars means `aws:elasticbeanstalk:application:environment` namespace values. See [here](http://docs.aws.amazon.com/elasticbeanstalk/latest/dg/command-options.html)

## Subcommands

- [add](#add)
- [rm](#rm)
- [show](#show)

<a name="add"></a>
### add

Add config vars to the specified environment.

```
ebfly config add -a [app] -e [env] -c [key1=value1 key2=value2 ...]
```

#### Options

| Name | Description                                                                                | Required |
| ---- | ------------------------------------------------------------------------------------------ | -------- |
| -a   | The name of the application to add config vars.                                            | Yes      |
| -e   | The name of the environment to add config vars.                                            | Yes      |
| -c   | The config vars formated `key=value`. Each key-value pair must be separated by whitespace. | Yes      |

#### Examples

- Set `RACK_ENV` to `production`.

```
ebfly config add -a app -e env -c RACK_ENV=production
```

- Set `ENV1` to `val1' and 'ENV2' to 'val2'.

```
ebfly config add -a app -e env -c ENV1=val1 ENV2=val2
```

<a name="rm"></a>
### rm

Remove config vars of the specified environment.

```
ebfly config rm -a [app] -e [env] -c [key1 key2 ...]
```

#### Options

| Name | Description                                                                 | Required |
| ---- | --------------------------------------------------------------------------- | -------- |
| -a   | The name of the application to remove config vars.                          | Yes      |
| -e   | The name of the environment to remove config vars.                          | Yes      |
| -c   | The config vars keys to remove. Each value must be separated by whitespace. | Yes      |

#### Examples

Remove `ENV1` and `ENV2`.

```
ebfly config rm -a app -e env -c ENV1 ENV2
```

<a name="show"></a>
### show

Show config vars of the specified environment.

```
ebfly config show -a [app] -e [env]
```

#### Options

| Name | Description                                                                 | Required |
| ---- | --------------------------------------------------------------------------- | -------- |
| -a   | The name of the application to remove config vars.                          | Yes      |
| -e   | The name of the environment to remove config vars.                          | Yes      |
