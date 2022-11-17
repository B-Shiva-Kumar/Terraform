# Terraform
This is a my Terraform repository, where I will be updating my templates for my reference.
Feel free to use for your reference also!


Terraform : tf is a tool for building, changing & versioning infrastructure safely & efficiently.

tf state file : 
- it is a JSON file containing inf. about every resource & data object.
- Contians sensitive inf. (eg. db pswd).
- can be stored locally or remotely.
- local backend  -> * sensitive values in plain txt.
                    * Uncollaborative.
                    * Manual.
              
- remote backend -> * terraform cloud | S3.
                    * senstivie data encrypted.
                    * collaboration possible.
                    * automation possible.
                    * Increased complexity.



Terraform Variables:

- Input variables.
- Output variables.
- Local variables.


Terraform Modules:

- Root Module.
- Child Module.
- Published Module.
