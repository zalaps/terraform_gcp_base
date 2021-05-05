# structure
## Understanding the directory structure
```
.
├── definitions
│   ├── resourse01
│   │   ├── main.tf
│   │   └── variables.tf
│   ├── resourse02
│   │   ├── main.tf
│   │   └── variables.tf
│   ├── resourse03
│   │   ├── main.tf
│   │   └── variables.tf
└── env
    ├── common.hcl
    ├── terragrunt.hcl
    ├── stage
    │   ├── credentials.json
    │   ├── env.hcl
    │   ├── regionA
    │   │   ├── resourse01
    │   │   │   └── terragrunt.hcl
    │   │   ├── resource04
    │   │   │   ├── main.tf
    │   │   │   ├── terragrunt.hcl
    │   │   │   └── variables.tf
    │   │   ├── region.hcl
    │   ├── global
    │   │   ├── resourse02
    │   │   │   └── terragrunt.hcl
    │   │   └── region.hcl
    │   └── regionB
    │       ├── resource03
    │       │   └── terragrunt.hcl
    │       └── region.hcl
    ├── prod
    │   └── ...
```

- **./definitions/** => All the resources which has same definition across the environments stay here. They will have independent hcl config file  in respective **./env/** directory. In above directory structure resource 01, 02 and 03 have same definition but different configuration accross the environments.
- **./env/common.hcl** => Common variables that apply across environments stay here.
- **./env/terragrunt.hcl** => Declarations for remote state and providers stay here.
- **./env/stage** => Root directory for all configurations controlled by environment _stage_.
- **./env/stage/env.hcl** => Configurations limited to environment _stage_ are declared here.
- **./env/stage/region/** => Root directory for all resource configurations for given region. In above directory structure region A and B are digfferent regions.
- **./env/stage/global** => All the resources which are not bounded to any region stays here.
- **./env/stage/regionA/resource04** => This is a example resource which is not having standard definition across environments and hence it's definition is stored directly in to the _stage_ directory. Similiarly _prod_ version of resource04 needs to be defined ar path **./env/prod/regionA/resource04**


## Preparation to get going 
- State of cloud infrastructure will be stored in backend file in Google Cloud bucket. Create bucket with name as required in file **./env/terragrunt.hcl**

### Terragrunt plan & apply
This project works with Terragrunt. Run following commands from root directory of required environment. e.g. for stage environment it would be **./env/stage/**. Commands can be run for individual resource group as well. e.g **./env/stage/regionA/resource01/**.
```
# Plan all resources in resource01
$ /env/stage/regionA/resource01/ terragrunt plan-all 

# Plan all resources in regionA
$ /env/stage/regionA/ terragrunt plan-all

Plan all resources in env stage
$ /env/stage/ terragrunt plan-all

Plan all resources across the environments 
$ /env/ terragrunt plan-all
```
### Terragrunt plan & apply
Similiarly, final make the changes with apply command.
```
terragrunt apply-all
```

### Terragrunt destroy
Undone infra changes by using following command. This will destroy actual infra.
```
terragrunt destroy-all 
```