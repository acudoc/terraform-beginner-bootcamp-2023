# Terraform Beginner Bootcamp 2023

## Table of Content :mage:
- [Semantic Versioning](#semantic-versioning)
- [Install the Terraform CLI](#install-the-terraform-cli)
  * [Considerations with the Terraform CLI changes](#considerations-with-the-terraform-cli-changes)
  * [Considerations for Linux Distribution](#considerations-for-linux-distribution)
  * [Refactoring into Bash Scripts](#refactoring-into-bash-scripts)
    + [Shebang Considerations](#shebang-considerations)
    + [Execution Considerations](#execution-considerations)
    + [Linux Permissions Considerations](#linux-permissions-considerations)
- [Gitpod Lifecycle](#gitpod-lifecycle)
  * [Working with Env Vars](#working-with-env-vars)
    + [env command](#env-command)
    + [Setting and Unsetting Env Vars](#setting-and-unsetting-env-vars)
    + [Print Vars](#print-vars)
    + [Scoping of Env Vars](#scoping-of-env-vars)
    + [Persist Env Vars in Gitpod](#persist-env-vars-in-gitpod)
  * [AWS CLI installation](#aws-cli-installation)
  * [Working with AWS resources in Terraform](#working-with-aws-resources-in-terraform)
    + [Naming S3 buckets with random](#naming-s3-buckets-with-random)
- [Terraform Basics](#terraform-basics)
  * [Terraform Registry](#terraform-registry)
  * [Terraform Console](#terraform-console)
    + [Terraform Init](#terraform-init)
    + [Terraform Plan](#terraform-plan)
    + [Terraform Apply](#terraform-apply)
    + [Terraform Destroy](#terraform-destroy)
  * [Terraform Lock Files](#terraform-lock-files)
  * [Terraform State Files](#terraform-state-files)
  * [Terraform Directory](#terraform-directory)
- [Issue with Terraform Cloud Login and Gitpod Workspace](#issue-with-terraform-cloud-login-and-gitpod-workspace)

## Semantic Versioning

This project will use semantic versioning for tagging.
[semver.org](https://semver.org/)

General format:

**MAJOR.MINOR.PATCH**, eg. `1.0.1`

- **MAJOR** version when you make incompatible API changes
- **MINOR** version when you add functionality in a backward compatible manner
- **PATCH** version when you make backward compatible bug fixes

## Install the Terraform CLI

### Considerations with the Terraform CLI changes
The Terraform CLI installation instructions changed due to gpg keyring changes. 
File was updated to the latest install CLI instructions via Terraform Documentation and changed the scripting for install.

[Install Terraform CLI](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)


### Considerations for Linux Distribution

This project is built against Ubunutu.
Please consider checking your Linux Distrubtion and change accordingly to distrubtion needs. 

[How To Check OS Version in Linux](
https://www.cyberciti.biz/faq/how-to-check-os-version-in-linux-command-line/)

Example of checking OS Version:

```
$ cat /etc/os-release

PRETTY_NAME="Ubuntu 22.04.3 LTS"
NAME="Ubuntu"
VERSION_ID="22.04"
VERSION="22.04.3 LTS (Jammy Jellyfish)"
VERSION_CODENAME=jammy
ID=ubuntu
ID_LIKE=debian
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
UBUNTU_CODENAME=jammy
```

### Refactoring into Bash Scripts

While fixing the Terraform CLI gpg depreciation issues we notice that bash scripts steps were a considerable amount more code. So we decided to create a bash script to install the Terraform CLI.

This bash script is located here: [./bin/install_terraform_cli](./bin/install_terraform_cli)

- This will keep the Gitpod Task File ([.gitpod.yml](.gitpod.yml)) tidy.
- This allow us an easier to debug and execute manually Terraform CLI install
- This will allow better portablity for other projects that need to install Terraform CLI.

#### Shebang Considerations

A Shebang (prounced Sha-bang) tells the bash script what program that will interpet the script. eg. `#!/bin/bash`

ChatGPT recommended this format for bash: `#!/usr/bin/env bash`

- for portability for different OS distributions 
-  will search the user's PATH for the bash executable

https://en.wikipedia.org/wiki/Shebang_(Unix)

#### Execution Considerations

When executing the bash script we can use the `./` shorthand notiation to execute the bash script.

eg. `./bin/install_terraform_cli`

If we are using a script in .gitpod.yml  we need to point the script to a program to interpert it.

eg. `source ./bin/install_terraform_cli`

#### Linux Permissions Considerations

In order to make our bash scripts executable we need to change linux permission for the fix to be exetuable at the user mode.

```sh
chmod u+x ./bin/install_terraform_cli
```

alternatively:

```sh
chmod 744 ./bin/install_terraform_cli
```

https://en.wikipedia.org/wiki/Chmod

## Gitpod Lifecycle

We need to be careful when using the Init because it will not rerun if we restart an existing workspace.

https://www.gitpod.io/docs/configure/workspaces/tasks

### Working with Env Vars 

#### env command

List out all Environment Variables (Env Vars) using `env`
Filter specific env vars using `env | grep AWS_`

#### Setting and Unsetting Env Vars

To set -> `export HELLO='world'`

To unset -> `unset HELLO`

To temporarily set ->

```sh
HELLO='world' ./bin/print_message
```

Within a bash script we can set with ->
```sh
#!/usr/bin/env bash

HELLO='world'

echo $HELLO
```

#### Print Vars

Print with -> `echo $HELLO`

#### Scoping of Env Vars

Env Vars DO NOT persitst across bash terminals.
To make a global env var it needs to be set in `.bash_profile`

#### Persist Env Vars in Gitpod

Use the following:
```
gp env HELLO='world'
```

### AWS CLI installation

This project installs via the bash script [`./bin/install_aws_cli`](./bin/install_aws_cli)

[Getting Started INstall (AWS CLI)](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
[AWS CLI Env Vars(Env Vars)](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html)

To check if AWS credentials are configured correctly, run following AWS CLI command:
```sh
aws sts get-caller-identity
```

Generate AWS CLI credentials from IAM User

[AWS IAM(Access Key)](https://docs.aws.amazon.com/cli/latest/userguide/cli-services-iam-create-creds.html)

If successful you will see a json formatted output:

```json
{
    "UserId": "AEWA3NVVGYUJHBHHIKFUC",
    "Account": "123456789012",
    "Arn": "arn:aws:iam::123456789012:user/terraform-boot"
}
```

### Working with AWS resources in Terraform

#### Naming S3 buckets with random

[AWS S3 Naming Rules](https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucketnamingrules.html)
[tf docs for S3 buckets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket)

Paramenters for the random string needed to be changed.
[hashicorp random doc](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string)

## Terraform Basics

### Terraform Registry

Terraform sources providers and modules. Located @ [registry.terraform.io/](https://registry.terraform.io/)

- **Providers** interface to APIs that allow tf to create resources.
Example of provider;
[Random Terraform Provider](https://registry.terraform.io/providers/hashicorp/random/latest)

- **Modules** Allows large amounts of tf code modular, portable, and sharable.

### Terraform Console

We can see list of all tf commands, using `terraform`

#### Terraform Init

To start new tf project; the command `terraform init` is run to download binaries for the choosen providers 

#### Terraform Plan

`terraform plan`

This generates a changeset; about the state of our infrastructure and what will be changed.

#### Terraform Apply

`terraform apply`

This runs a plan and passes the changeset to be excuted by terraform. Apply should prompt yes or no.

To automatically aprove an apply, use: `terraform apply --auto-aprove`

#### Terraform Destroy

This commands deletes resources from previous terraform apply.
`terraform destroy`

### Terraform Lock Files

`.terraform.lock.hcl`
Contains the locked versioning of the providers or modules that are used in the project.

**Should be committed** to version control system.


### Terraform State Files

`terraform.tfstate`

Information about the current state. Can be sensitive data.

**Should NOT be committed**

`terraform.tfstate.backup` is the previous state file.

### Terraform Directory

`.terraform` contains binaries of terraform providers

## Issue with Terraform Cloud Login and Gitpod Workspace

Attempting to run `terraform login` a bash wiswig panel view is launched to produce a token. Working in Gitpod VScode in browser the token could not be copied.

The workaround
- Manually generate a token in Terraform Cloud

```
https://app.terraform.io/app/settings/tokens?source=terraform-login
```

Then create file manually here:

```sh
touch /home/gitpod/.terraform.d/credentials.tfrc.json
```
Open and add your tf cloud token.

```json
{
   "credentials": {
     "app.terraform.io": {
        "token": "YOUR-TERRAFORM-CLOUD_TOKEN"
    }
  }
}

```

At 0.8.0 the above workaround was automated with the following bash script:
[bin/generate_tfrc_credentials](bin/generate_tfrc_credentials)
