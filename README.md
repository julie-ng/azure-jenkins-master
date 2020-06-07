# Jenkins Master pre-configured for Azure

The `lts` tag automatically follows the upstream Jenkins `lts` tag, installing the latest Azure CLI tool.

## Releases

| Date Published | Tag | Jenkins Version | Azure CLI Version |
|:--|:--|:--|:--|
| ? June 2020 | `lts` | `lts` or 2.222.3 | 2.7.0 |

Version reference for Azure CLI and Jenkins:

- [Azure CLI Version History](https://docs.microsoft.com/en-us/cli/azure/release-notes-azure-cli?view=azure-cli-latest)
- [Jenkins Changelog](https://www.jenkins.io/changelog/)
- [Jenkins Changelog - LTS](https://www.jenkins.io/changelog-stable/)

### Building from `jenkins:lts`

This image extends the Jenkins Long Term Support (LTS) image, instead of default latest. Because we use the `lts` tag, the image will be cached on your machine. Make sure to first grab the latest LTS image before building:

```bash
docker pull jenkins/jenkins:lts
docker build .
```

## Configuration as Code

This image uses the [Configuration as Code Plugin](https://plugins.jenkins.io/configuration-as-code/). This originally started as an independent project but has been proposed to be integrated as standard into Jenkins and the [was accepted](https://github.com/jenkinsci/jep/tree/master/jep/201) in 2017. This image uses CasC.

Documentation is generally found _not_ on the official Jenkins website, but in their official [jenkinsci](ttps://github.com/jenkinsci/) Github organization. For reference:

- [AAD Integration](https://github.com/jenkinsci/configuration-as-code-plugin/tree/master/demos/active-directory)
- [Matrix Authorization](https://github.com/jenkinsci/matrix-auth-plugin/blob/master/src/test/resources/org/jenkinsci/plugins/matrixauth/integrations/casc/configuration-as-code.yml)

Individual config for this image are found in the [`config/`](./config/) folder.

## Azure AD Integration

- [Jekins Plugin: Azure AD](https://plugins.jenkins.io/azure-ad/) (maintined by the Azure DevOps team and [source is on GitHub](https://github.com/jenkinsci/azure-ad-plugin))

### Security

- [Jenkins Handbook: Managing Security](https://www.jenkins.io/doc/book/managing/security/)
- [Jenkins wiki: Standard Security Setup](https://wiki.jenkins.io/display/JENKINS/Standard+Security+Setup)
- [Jenkins wiki: Matrix-based security](https://wiki.jenkins.io/display/JENKINS/Matrix-based+security)
- [Jenkins Handbook: In-process Script Approval](https://www.jenkins.io/doc/book/managing/script-approval/)  
  Requires groovy script entering entiring script (or method signature) into configuration
- [Cloudbees Blog: Securing Jenkins with Role-based Access Control and Azure Active Directory](https://www.previous.cloudbees.com/blog/securing-jenkins-role-based-access-control-and-azure-active-directory)


## Plugins

We also preloaded our Jenkins with some plugins for our toolchain and an improved workflow:

- [NodeJS Plugin](https://plugins.jenkins.io/nodejs)
- [Pipeline 2.5](https://plugins.jenkins.io/workflow-aggregator) for latest syntax including declarative pipelines
- [Pipeline Utility Steps](https://plugins.jenkins.io/pipeline-utility-steps) for zipping files
- [Pipeline: Build Step](https://plugins.jenkins.io/pipeline-build-step) for triggering other jobs
- [Job DSL](https://plugins.jenkins.io/job-dsl) for programmatically adding jobs
- [Timestamper](https://plugins.jenkins.io/timestamper) for timestamps in console output
- [Blue Ocean](https://plugins.jenkins.io/blueocean) for a redesigned Jenkins experience
- [Artifactory](https://plugins.jenkins.io/artifactory) for managing our build artifacts

## Test Locally

You can test this image locally using

```
docker-compose up --build
```

Then you can login to [http://localhost:8080](http://localhost:8080/) using

- username: `admin`
- password: `badidea`

## Export Plugin Versions

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