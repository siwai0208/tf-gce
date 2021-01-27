# **GCE by Terraform**

## **About**

Make New GCE Instanse with following packages
- mysql5.7
- nginx1.18
- php7.3
- [sample-laravel-app](https://github.com/siwai0208/food-app)

## **How to Use**

**1. Make .tfvars file from sample**

    mv terraform.tfvars.sample terraform.tfvars

**2. Set following parameter in terraform.tfvars**

- gcp_project
- region
- zone
- subnetspub1cidr (default: 10.0.16.0/24)
- subnetspub2cidr (default: 10.0.17.0/24)
- subnetsprv1cidr (default: 10.0.24.0/24)
- subnetsprv2cidr (default: 10.0.25.0/24)
- sshlocation
- httplocation
- machine_type (default: f1-micro)
- dbuser
- dbpassword
- dbname
- gituser
- gitemail
- gitpassword
- username
- userpass

**3. Authenticate with GCP**

```
$ gcloud auth application-default login

Go to the following link in your browser:

Enter verification code: 

Credentials saved to file: [path]が表示される
```

*How to start ssh session for GCE instance

```
$ gcloud compute ssh [username]@webserver --zone=[zonename]
```


**4. Run commands using the terraform**
```
$ terraform init
  ...
$ terraform apply
  ...
  Enter a value: yes
  ...
  Apply complete!

  Outputs:
  instance-ipaddress = "GCE-global-IP"
```

**5. Access to sample-app**
```
 http://[GCE-global-IP]
```

**6. Destroy GCE Instance**
```
$ terraform destroy
  ...
  Enter a value: yes
  ...
  Destroy complete! 
```
