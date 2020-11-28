# mythic-deploy
Automated deployment and configuration of a Mythic server using Terraform and Ansible

## Prerequisites 
* [Install Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)
* [Install Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)

## How to Deploy
### Terraform
1. `git clone https://github.com/0xdeadbeefJERKY/mythic-deploy`
2. `cd mythic-deploy/terraform`
3. Create `main.tf`, using the `.tf` files in `terraform/examples` for guidance
   * e.g., `cp examples/digitalocean.tf main.tf`
4. `cp terraform.tfvars.example terraform.tfvars`
5. Modify `terraform.tfvars` as needed
6. Configure provider authentication
   * [AWS](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#authentication)
   * [Digital Ocean](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs#argument-reference)
   * [Google Cloud](https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/getting_started)
7. `terraform init`
8. `terraform plan` and review the output
   * Optionally, run `terraform plan -out terraform.tfplan` to save the Terraform plan locally.
9.  `terraform apply`

### Ansible
1. `cd mythic-deploy/ansible`
2. Modify `roles/mythic/files/config.json` to customize the Mythic deployment
3. `ansible-playbook -i inventory site.yml`

### Start Mythic
1. SSH into the Mythic server (e.g., `cd mythic-deploy/terraform && $(terraform output ssh_connect_cmd)`)
2. From SSH session, run `cd $HOME/mythic && sudo ./start_mythic.sh`
3. Open browser, navigate to https://<instance_ip>:7443 and log in using the credentials from `ansible/roles/mythic/files/config.json`