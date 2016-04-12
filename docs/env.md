# env

`env` is a command for managing ElasticBeanstalk environment.

## Subcommands

- [create](#create)
- [delete](#delete)
- [update](#update)
- [info](#info)
- [open](#open)
- [push](#push)

<a name="create"></a>
### create

Create an environment.

```
ebfly env create [name] -a [app] -s [stack] -t [tier] -l [label] -o [namespace-key=value ...] -d [desc]
```

#### Options

| Name | Description                                                                                    | Required |
| ---- | ---------------------------------------------------------------------------------------------- | -------- |
| -a   | The application name to create environment.                                                    | Yes      |
| -s   | The Solution stack name to create. Some [predefined values](#predefined_values) are available. | Yes      |
| -t   | Tier type, value must be `web` or `worker`. Default value is `web`                             | No       |
| -l   | The name of the application version to deploy                                                  | No       |
| -o   | ElasticBeanstalk option values. For detail see [Option Values](#option_values) section         | No       |
| -d   | The description of the application.                                                            | No       |

#### Examples

Create Ruby 1.9 web environment.

```
ebfly env create envname -a app -s ruby19 -t web
```

Create Python 2.7 worker environment with option values.

```
ebfly env create envname -a app -s python27 -t worker -o -o sqsd-MimeType="text/plain" sqsd-HttpPath="/enqueue"
```

<a name="predefined_values"></a>
#### Predefined solution stack name

You can specify full defined name, see in http://docs.aws.amazon.com/elasticbeanstalk/latest/dg/concepts.platforms.html

##### Current

| Name           | Defined value                                                                    |
| ---------------| -------------------------------------------------------------------------------- |
| docker19       | 64bit Amazon Linux 2016.03 v2.1.0 running Docker 1.9.1                           |
| go             | 64bit Amazon Linux 2016.03 v2.1.0 running Go 1.4                                 |
| nodejs         | 64bit Amazon Linux 2016.03 v2.1.0 running Node.js                                |
| php55          | 64bit Amazon Linux 2016.03 v2.1.0 running PHP 5.5                                |
| php56          | 64bit Amazon Linux 2016.03 v2.1.0 running PHP 5.6                                |
| python27       | 64bit Amazon Linux 2016.03 v2.1.0 running Python 2.7                             |
| python34       | 64bit Amazon Linux 2016.03 v2.1.0 running Python 3.4                             |
| ruby19         | 64bit Amazon Linux 2016.03 v2.1.0 running Ruby 1.9.3                             |
| ruby20         | 64bit Amazon Linux 2016.03 v2.1.0 running Ruby 2.0 (Passenger Standalone)        |
| ruby20-puma    | 64bit Amazon Linux 2016.03 v2.1.0 running Ruby 2.0 (Puma)                        |
| ruby21         | 64bit Amazon Linux 2016.03 v2.1.0 running Ruby 2.1 (Passenger Standalone)        |
| ruby21-puma    | 64bit Amazon Linux 2016.03 v2.1.0 running Ruby 2.1 (Puma)                        |
| ruby22         | 64bit Amazon Linux 2016.03 v2.1.0 running Ruby 2.2 (Passenger Standalone)        |
| ruby22-puma    | 64bit Amazon Linux 2016.03 v2.1.0 running Ruby 2.2 (Puma)                        |
| ruby23         | 64bit Amazon Linux 2016.03 v2.1.0 running Ruby 2.3 (Passenger Standalone)        |
| ruby23-puma    | 64bit Amazon Linux 2016.03 v2.1.0 running Ruby 2.3 (Puma)                        |

<a name="delete"></a>
### delete

Delete the specified environment.

```
ebfly env delete [name] -a [app]
```

#### Options

| Name | Description                                 | Required |
| ---- | ------------------------------------------- | -------- |
| -a   | The application name to create environment. | Yes      |

<a name="update"></a>
### update

Update an environment.

```
ebfly env update [name] -a [app] -l [label] -o [namespace-key=value ...] -d [desc]
```

#### Options

| Name | Description                                                                                    | Required |
| ---- | ---------------------------------------------------------------------------------------------- | -------- |
| -a   | The application name to create environment.                                                    | Yes      |
| -l   | The name of the application version to deploy                                                  | No       |
| -o   | ElasticBeanstalk option values. For detail see [Option Values](#option_values) section         | No       |
| -d   | The description of the application.                                                            | No       |

<a name="info"></a>
### info

Show the specified environment information.

```
ebfly env info [name] -a [app]
```

#### Options

| Name | Description                                 | Required |
| ---- | ------------------------------------------- | -------- |
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
| ---- | ------------------------------------------- | -------- |
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

<a href="option_values"></a>
## Option Values

Option values format is `namespace-key=value` style.
Which `namespace`, `key` and `value` can be used is describe at [AWS Elastic Beanstalk official document](http://docs.aws.amazon.com/elasticbeanstalk/latest/dg/command-options.html).

You can use short `namespace` as followings.

| Short namespace      | Real namespace                              |
| -------------------- | ------------------------------------------- |
| asg                  | aws:autoscaling:asg                         |
| launchconfiguration  | aws:autoscaling:launchconfiguration         |
| trigger              | aws:autoscaling:trigger                     |
| rollingupdate        | aws:autoscaling:updatepolicy:rollingupdate  |
| vpc                  | aws:ec2:vpc                                 |
| application          | aws:elasticbeanstalk:application            |
| command              | aws:elasticbeanstalk:command                |
| environment          | aws:elasticbeanstalk:environment            |
| monitoring           | aws:elasticbeanstalk:monitoring             |
| topics               | aws:elasticbeanstalk:sns:topics             |
| sqsd                 | aws:elasticbeanstalk:sqsd                   |
| healthcheck          | aws:elb:healthcheck                         |
| loadbalancer         | aws:elb:loadbalancer                        |
| policies             | aws:elb:policies                            |
| dbinstance           | aws:rds:dbinstance                          |
| hostmanager          | aws:elasticbeanstalk:hostmanager            |

### Example

Set `InstanceType` of `aws:autoscaling:launchconfiguration` to `m1.small`

```
ebfly env update name -a app -o launchconfiguration-InstanceType="m1.small"
```
