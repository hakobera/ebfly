# env

`env` is a command for managing ElasticBeanstalk environment.

## Subcommands

- [create](#create)

<a name="create"></a>
### create

Create an environment.

```
ebfly env create [name] -a [app] -s [stack] -t [tier] -l [label] -d [desc]
```

#### Options

| Name | Description                                                                                    | Required |
| -----|:----------------------------------------------------------------------------------------------:| --------:|
| -a   | The application name to create environment.                                                    | Yes      |
| -s   | The Solution stack name to create. Some [predefined values](#predefined_values) are available. | Yes      |
| -t   | Tier type, value must be `web` or `worker`. Default value is `web`                             | No       |
| -l   | The name of the application version to deploy                                                  | No       |
| -d   | The description of the application.                                                            | No       |

#### Examples

Create Ruby 1.9 web environment.

```
ebfly env create envname -a app -s ruby19 -t web
```

Create Python 2.7 worker environment.

```
ebfly env create envname -a app -s python27 -t worker
```

<a name="predefined_values"></a>
#### Predefined solution stack name

| Name     | Defined value                                      |
| ---------|:--------------------------------------------------:|
| java7    | 64bit Amazon Linux 2013.09 running Tomcat 7 Java 7 |
| java6    | 64bit Amazon Linux 2013.09 running Tomcat 7 Java 6 |
| nodejs   | 64bit Amazon Linux 2013.09 running Node.js         |
| php53    | 64bit Amazon Linux running PHP 5.3                 |
| php54    | 64bit Amazon Linux 2013.09 running PHP 5.4         |
| php55    | 64bit Amazon Linux 2013.09 running PHP 5.5         |
| python27 | 64bit Amazon Linux 2013.09 running Python 2.7      |
| ruby18   | 64bit Amazon Linux 2013.09 running Ruby 1.8.7      |
| ruby19   | 64bit Amazon Linux 2013.09 running Ruby 1.9.3      |

<a name="delete"></a>
### delete

Delete the specified environment.

```
ebfly env delete [name] -a [app]
```

#### Options

| Name | Description                                 | Required |
| -----|:-------------------------------------------:| --------:|
| -a   | The application name to create environment. | Yes      |

<a name="info"></a>
### info

Show the specified environment information.

```
ebfly env info [name] -a [app]
```

#### Options

| Name | Description                                 | Required |
| -----|:-------------------------------------------:| --------:|
| -a   | The application name to create environment. | Yes      |
| -r   | Show environment resources.                 | No       |

<a name="open"></a>
### open

Open environment CNAME in browser (Mac OS Only)

```
ebfly env open [name] -a [app]
```

#### Options

None

<a name="push"></a>
### push

Push and deploy the specified branch to the environment.

```
ebfly env push [name] [branch or tree_ish] -a [app]
```

#### Options

| Name | Description                                 | Required |
| -----|:-------------------------------------------:| --------:|
| -a   | The application name to create environment. | Yes      |

#### Examples

Push `master` branch to the environment.

```
ebfly env push envname master -a app
```

Push specified commit `66c598c` to the environment.

```
ebfly env push envname 66c598c -a app
```
