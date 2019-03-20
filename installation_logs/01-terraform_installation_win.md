# Installing Terraform for Windows
Sources: https://learn.hashicorp.com/terraform/getting-started/install.html

## Download the binary:
https://www.terraform.io/downloads.html

We've downloaded v0.11.13 (64-bit): https://releases.hashicorp.com/terraform/0.11.13/terraform_0.11.13_windows_amd64.zip

## Unzip the package to desired folder:
We normally install tooling under `C:\tools`, so we unzipped it to `C:\tools\terraform_0.11.13_windows_amd64`

## Set the environment variables:
I'm assuming you know your way around Windows environement variables, so go there and create a new variable called `TERRAFORM_HOME` with the folder path of the Terraform binary from the previous step.
We will use this variable to add it to the `Path` variable by appending `%TERRAFORM_HOME%` to the end of its value.

## Test the installation:
Now we open any command line terminal and execute `terraform --version` and if everything is OK we should have a similar output to: `Terraform v0.11.13`
