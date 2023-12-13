### Remote Execution
Terraform Provisioners can be used to model specific actions on the local machine or a remote machine to prepare servers or other infrastructure objects for service, like installing a 3rd-party application after the creation of virtual machines.

There are mainly two types of Provisioners:

#### 1. local-exec Provisioner: 
The local-exec provisioner invokes a local executable after a resource is created. This invokes a process on the machine running Terraform, not on the resource.

#### 2. remote-exec Provisioner: 
The remote-exec provisioner invokes a script on a remote resource after it is created. This can be used to run a configuration management tool, bootstrap into a cluster, etc.
Now let’s look into the remote-exec provisioner, it contains the type of the provisioner and a connection block which talks about how the connection to the VM will be made (like SSH, WinRM etc..)
In the above code you can see the provisioner used is “remote-exec”, it will connect the VM through SSH protocol using the username and pem file defined as variables in the TF code and it will SSH the target VM using the Public IP address. As soon as the connection gets established it will install docker, docker-compose, git, kubectl.