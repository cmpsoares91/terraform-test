# Preparing AWS IAM Credentials to access the ressources
Sources:

https://learn.hashicorp.com/terraform/getting-started/build

https://aws.amazon.com/pt/blogs/apn/terraform-beyond-the-basics-with-aws/

https://www.terraform.io/docs/providers/aws/index.html

https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html

## Creating a IAM user:
> An AWS Identity and Access Management (IAM) user is an entity that you create in AWS to represent the person or application that uses it to interact with AWS. A user in AWS consists of a name and credentials.

Source: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_users.html

 * To create a new IAM user we need to log in to our AWS Console account and go to the following page: https://console.aws.amazon.com/iam/home?#security_credential
 * Click on the `Add user` button, in the next page name the user what you want (for this test we're naming it `terraform-test`) and select the as **Access type**: "Programmatic access". Finish this step by clicking "next"
 * If we do not have a IAM group yet we should create it here:
    * Click on the "Create group" button
	* Name it what you want, we named it `terraform-test-group`
	* To simplify this example, let's give it the role policy `SystemAdministrator`, so in the search box search for it and select this option.
	* Then click on the "Create group" button.
 * And for the user make sure this group is selected before on the "Next" button.
 * On the next page you can add optional tags, you can add what you find usefull and then click on the "Next" button.
 * On this next page check the options you just filled in and click on the "Create User" button.
 * On this last page download the CSV file with the credentials so we can set it up in the next steps.
 
## Add the credentials to local user AWS configuration files

 * Create the AWS configuration folder in the Windows User Profile: `%UserProfile%\.aws`
 * Create the file to store the sensitive credential information (`%UserProfile%\.aws\credentials`)
 * Create the file to store less sensitive configuration options (`%UserProfile%\.aws\config`)
 * Add the credentials for the user we've just created to the file `%UserProfile%\.aws\credentials` like this example:
 ```
[default]
aws_access_key_id=AKIAIOSFODNN7EXAMPLE
aws_secret_access_key=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
 ```
 
 * Add the other AWS configurations to the file `%UserProfile%\.aws\config` like this example:
 ```
[default]
region=us-west-2
output=json
 ```
 
