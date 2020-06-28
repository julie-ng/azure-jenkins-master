# Jenkins Master pre-configured for Azure

The `lts` tag automatically follows the upstream Jenkins `lts` tag, installing the latest Azure CLI tool.

## Jenkins and Azure CLI Releases

| Date Published | Tag | Jenkins Version | Azure CLI Version |
|:--|:--|:--|:--|
| ?? 2020 | `-` | `lts` or 2.235.1 | 2.7.0 |

Version reference for Azure CLI and Jenkins:

- [Azure CLI Version History](https://docs.microsoft.com/en-us/cli/azure/release-notes-azure-cli?view=azure-cli-latest)
- [Jenkins Changelog](https://www.jenkins.io/changelog/)
- [Jenkins Changelog - LTS](https://www.jenkins.io/changelog-stable/)

## Pre-installed Plugins

### Jenkins Functionality

These plugins are preloaded for improved workflow.

| Plugin | Description | Version |
|:--|:--|:--|
| [Pipeline](https://plugins.jenkins.io/workflow-aggregator) | Adds pipeline functionality incl. multibranch and stages, declarative pipeline synxtax, etc. | 2.6 |
| [Job DSL](https://plugins.jenkins.io/job-dsl) | Seeds jobs, incl. with [JCasC](https://github.com/jenkinsci/job-dsl-plugin/wiki/JCasC) | 1.77 |
| [Timestamper](https://plugins.jenkins.io/timestamper) | Adds timestamps in console output | 1.11.3 |
| [Blue Ocean](https://plugins.jenkins.io/blueocean) |  Adds redesigned Jenkins experience | 1.23.2 |
| [Role-based Authorization Strategy](https://plugins.jenkins.io/role-strategy/) | Add role-based mechanism for Authorization | 3.0 |

### Azure Integration

These plugins are preloaded for integration with Azure.

| Plugin | Description | Version |
|:--|:--|:--|
| [Azure AD](https://plugins.jenkins.io/azure-ad) | Azure AD integration for authenication and authorization | 1.2.0 |
| [Azure Credentials Plugin](https://plugins.jenkins.io/azure-credentials/) | Jenkins plugin to manage Azure credentials | 4.0.2 |
| [Azure Key Vault](https://plugins.jenkins.io/azure-keyvault/) | Fetch secrets from Azure Keyvault for use in pipelines | 2.0 |
| [Azure VM Agents](https://plugins.jenkins.io/azure-vm-agents/) | Spin up Jenkins agents using Azure Virtual Machines | 1.5.0 |


## Azure AD Matrix-based security

In Azure AD, find "API permissions" for your app registration and set the following permissions.

#### Azure Active Directory Graph

| API Permission | Type | Description |
|:--|:--|:--|
| Directory.ReadAll | Application | Read directory data |
| User.Read | Delegated | Sign in and read user profile |

#### Microsoft Graph

| API Permission | Type | Description |
|:--|:--|:--|
| Directory.ReadAll | Application | Read directory data |
| User.read | Delegated | Sign in and read user profile |



## Jenkins Configuration as Code (JCasC)

This image uses the [Configuration as Code Plugin](https://plugins.jenkins.io/configuration-as-code/). This originally started as an independent project and now [standard Jenkins](https://github.com/jenkinsci/jep/tree/master/jep/201). Documentation is generally found _not_ on the official Jenkins website, but in their official [jenkinsci](ttps://github.com/jenkinsci/) Github organization. For reference:

- ~~[Active Directory](https://github.com/jenkinsci/configuration-as-code-plugin/tree/master/demos/active-directory)~~
- [Matrix Authorization](https://github.com/jenkinsci/matrix-auth-plugin/blob/master/src/test/resources/org/jenkinsci/plugins/matrixauth/integrations/casc/configuration-as-code.yml)

Individual configuration files for this image are found in the [`config/`](./config/) folder.

For more properties and examples see
[https://github.com/jenkinsci/configuration-as-code-plugin](https://github.com/jenkinsci/configuration-as-code-plugin/blob/master/demos/jenkins/jenkins.yaml)

#### Exporting Config

- [JSasC Docs: Exporting configurations](https://github.com/jenkinsci/configuration-as-code-plugin/blob/master/docs/features/configExport.md) --> open http://localhost:8080/configuration-as-code/


## Development

### Test Locally

You can test this image locally using

```
docker-compose up --build
```

Then you can login to [http://localhost:8080](http://localhost:8080/) using

- username: `admin`
- password: `badidea`

### Export Plugin Versions

To get a list of latest versions via the REST API, we need the credentials. Instead of referencing that directly in the command, we'll export the host instead. Replace `<USERNAME>` and `<PASSWORD>` with your credentials. This will export *all* installed plugins including dependencies.

```
export JENKINS_HOST=<USERNAME>:<PASSWORD>@localhost:8080
```

Then output your list to the console:

```
curl -sSL "http://$JENKINS_HOST/pluginManager/api/xml?depth=1&xpath=/*/*/shortName|/*/*/version&wrapper=plugins" | perl -pe 's/.*?<shortName>([\w-]+).*?<version>([^<]+)()(<\/\w+>)+/\1 \2\n/g'|sed 's/ /:/'
```

## Note

This is an a docker image for a Jenkins master originally based on my previous work for a [CI Demo built for Allianz Germany](https://github.com/allianz-de/cidemo-jenkins) under MIT license.

## Resources

A curated list of Jenkins resources and documentaiton.

### Security

- [Jenkins Handbook: Managing Security](https://www.jenkins.io/doc/book/managing/security/)
- [Jenkins wiki: Standard Security Setup](https://wiki.jenkins.io/display/JENKINS/Standard+Security+Setup)
- [Jenkins wiki: Matrix-based security](https://wiki.jenkins.io/display/JENKINS/Matrix-based+security)
- [Jenkins Handbook: In-process Script Approval](https://www.jenkins.io/doc/book/managing/script-approval/)  
  Requires groovy script entering entiring script (or method signature) into configuration
- [Cloudbees Blog: Securing Jenkins with Role-based Access Control and Azure Active Directory](https://www.previous.cloudbees.com/blog/securing-jenkins-role-based-access-control-and-azure-active-directory)
