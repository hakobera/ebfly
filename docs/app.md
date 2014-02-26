# app

`app` is a command for managing ElasticBeanstalk application.

## Subcommands

- [create](#create)
- [delete](#delete)
- [info](#info)
- [versions](#versions)

<a name="create"></a>
### create

Create an application.

```
ebfly app create [name] -d [desc]
```

#### Options

| Name | Description                         | Required |
| ---- | ----------------------------------- | -------- |
| -d   | The description of the application. | No       |

<a name="delete"></a>
### delete

Delete the specified application.

```
ebfly app delete [name] -f
```

#### Options

| Name | Description                                                                               | Required |
| ---- | ----------------------------------------------------------------------------------------- | -------- |
| -f   | Determines if all running environments should be deleted before deleting the application. | No       |

<a name="info"></a>
### info

Show the specified application information.

```
ebfly app info [name]
```

#### Options

None

<a name="versions"></a>
### versions

Show the application versions of specified application.

```
ebfly app versions [name]
```

#### Options

None
