# Prepare RSA Key for SSH connections

## Create key pair for SSH connection to the EC2 instance
Allthough the keys can be generated and deployed in many ways we're creating it locally in our repository folder just to simplify this example.

### Using the ssh-keygen command let's create our key pairs:
 * So in a terminal in our project directory, execute the command: `ssh-keygen -t rsa -b 4096 -C "your_email_used_at_aws@example.com"`
 * It will ask for a key name, so to work with our terraform configurations let's call it: `terraform-test-keys`
 * When prompted for a passphrase please just hit enter to create a key without it.
 * And it should've created a `terraform-test-keys` and a `terraform-test-keys.pub` file.

### Now change the permissions of the `terraform-test-keys` file:
`chmod 400 terraform-test-keys`

This Key will be used by the Terraform CLI when applying our configurations.

However if you want to access the created EC" instances afterwards, you can do it like:
`ssh -i "terraform-test-keys" ubuntu@<put_IP_or_Address_here>`
