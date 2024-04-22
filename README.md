# libvirt-terraform

This project provides a Terraform configuration to create a set of Ubuntu 22.04 virtual machines (VMs) on a libvirt-based infrastructure. The VMs are provisioned with Docker, Ansible, and various other tools pre-installed, making it easier to set up a development or testing environment.

## Prerequisites

Before you begin, ensure that your Linux environment meets the following requirements:

1. **Virtualization Support**: Your CPU must have virtualization capabilities. You can check this by running the following command:

```egrep -c '(svm|vmx)' /proc/cpuinfo```


If the command returns a number greater than 0, your CPU supports virtualization.

2. **libvirt Installation**: Install the necessary libvirt packages:

```sudo dnf install virt-top libguestfs-tools virt-manager # For Fedora-based systems```


3. **libvirtd Service**: Start and enable the libvirtd service:

```sudo systemctl enable --now libvirtd```


4. **Terraform Installation**: Download and install Terraform. You can find the latest version from the [Terraform downloads page](https://www.terraform.io/downloads.html).

5. **terraform-provider-libvirt Installation**: Download and install the Terraform libvirt provider. You can find the latest version from the [terraform-provider-libvirt releases page](https://github.com/dmacvicar/terraform-provider-libvirt/releases).

## Usage

1. Clone the repository and navigate to the project directory:

*git clone https://github.com/your-username/libvirt-terraform.git cd libvirt-terraform*


2. Initialize the Terraform working directory:

```terraform init```


3. Review and customize the Terraform configuration files as needed:
- `main.tf`: This file sets up the Terraform provider and calls the VM module.
- `modules/vm/main.tf`: This file contains the VM-related resources.
- `modules/vm/variables.tf`: This file defines the input variables for the VM module.
- `modules/vm/outputs.tf`: This file defines the output variables for the VM module.

Ensure that you update the `ssh_authorized_keys` in the `modules/vm/cloud_init.cfg` file with your own SSH public key.

4. Apply the Terraform configuration to create the VMs:

```terraform apply```


This will prompt you to confirm the changes. Enter `yes` to proceed.

5. Verify the created VMs:

```virsh list --all virsh net-dhcp-leases vm_network```


The first command will list all the VMs, and the second command will show the DHCP lease information for the `vm_network`.

6. Connect to the VMs using SSH:

```ssh developer@<VM_IP_ADDRESS>```


Replace `<VM_IP_ADDRESS>` with the IP address of one of the created VMs.

## Outputs

After applying the Terraform configuration, you can retrieve the IP addresses of the created VMs using the following output:

```terraform output vm_ips```


This will display a list of the IP addresses for each VM.

## Cleanup

When you're done, you can destroy the created resources using Terraform:

```terraform destroy```


This will remove all the VMs and associated resources from your libvirt environment.

## Kasm Installation

The Terraform configuration includes steps to install Kasm on the created VMs using cloud-init. The installation process is as follows:

1. The `kasm_release` variable in the `modules/vm/main.tf` file specifies the desired Kasm release version. You can update this variable to install a different version of Kasm.

2. The `modules/vm/cloud_init.cfg` file includes the following steps to install Kasm:
   - Downloads the specified Kasm release package from the Kasm static content S3 bucket.
   - Extracts the downloaded package.
   - Runs the Kasm installation script (`install.sh`) from the extracted package.

3. When you run `terraform apply`, the VMs will be created, and Kasm will be automatically installed on each VM as part of the cloud-init process.

4. After the Terraform deployment is complete, you can access the Kasm web interface by navigating to the IP address of the VM in a web browser.

Note: Make sure to review and update the `kasm_release` variable in the `modules/vm/main.tf` file if you want to install a different version of Kasm.



## Troubleshooting

If you encounter any issues during the installation or usage, please check the following:

1. Ensure that your system meets all the prerequisite requirements.
2. Verify the Terraform configuration files for any errors or typos.
3. Check the libvirt logs for any relevant error messages.

If you continue to experience problems, feel free to reach out to the project maintainers or the Terraform community for assistance.

## Additional Resources

- [Terraform documentation](https://www.terraform.io/docs/index.html)
- [libvirt Terraform provider documentation](https://github.com/dmacvicar/terraform-provider-libvirt)
- [libvirt project documentation](https://libvirt.org/docs.html)
The key changes in the updated README.md file are:

Added a new "Outputs" section to explain how to retrieve the IP addresses of the created VMs.
Provided more details on the structure of the Terraform configuration, including the purpose of the different files (main.tf, modules/vm/main.tf, modules/vm/variables.tf, modules/vm/outputs.tf).
Ensured that the instructions for using the Terraform configuration are up-to-date and consistent with the changes made to the files.
The updated README.md file should provide a more comprehensive and clear guide for users to understand, use, and maintain the libvirt-terraform project.