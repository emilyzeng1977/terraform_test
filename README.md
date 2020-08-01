# It's for terraform certification examination 
main.tf.pub -> it's to create an ec2 with public ip
main.tf.pub_pri -> it's to create an ec2 in public subnet and an ec2 in private subnet
main.if.init_backen -> it will create s3 and dynamodb table for backend

====================================

3.Terraform basic
provisioner
Task1: execute local-exec
1). cp main.tf.s3 main.tf
2). copy the below code into the resource of demo
  provisioner "local-exec" {
    command = "echo $USER >> local_user.txt"
  }

Task2: execute remote-exec
1). cp main.tf.pub.ec2 main.tf
2). copy the below code into the resource of tf_demo_pub

provisioner "remote-exec" {
  connection {
    type        = "ssh"
    user        = "ec2-user"
    host        = self.public_ip
    private_key = file("~/Study/TomKeyPair.pem")
  }

  inline = [
    "echo $USER >> /tmp/local_user.txt",
  ]
}

provisioner "file" {
  source      = “./script/demo.sh"
  destination = "/tmp/demo.sh"
}





4.Terraform CLI
terraform refresh
terraform graph ?
terraform state mv

terraform import resource ID 
Task: understand the usage of resource file, state mv, import and refresh
1). copy main.tf.s3 main.tf
2). terraform apply  // Create S3
3). terraform state list // list all the resource
4). terraform state mv aws_s3_bucket.demo
5). terraform refresh or destory // could just refresh and destroy the resources managed
6). terraform import aws_s3_bucket.demo tom.niu14.tf.demo
7). terraform refresh
8). Login the console and update this S3 (supporting versioning)
9). terraform refresh

terraform taint
Task: understand the concept about taint
1). copy main.tf.s3 main.tf
2). terraform apply
3). terraform taint aws_s3_bucket.demo
4). terraform apply // You will see it firstly destroy this resource and then create a new one

5.Modules
https://learn.hashicorp.com/terraform/modules/using-modules
Task1: Create EC2 by modules
— main.tf —
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.21.0"
  name = "nyz.vpc"
  cidr = var.vpc_cidr
  azs           = var.vpc_azs
  private_subnets  = var.vpc_private_subnets
  tags = {
    Name = "nyz.tf-module"
  }
}
Task2: Understand variables type
There are 2 complex types:
* Collections: list, map, set
* Structural: object, tuple
We use length(collections) to obtain the size of the collections. 
Collection types are usually multiple values of the same type grouped under a single collection
Occasionally, we may also need to mix types. We can either create custom structural types or use tuples.

1). cp main.tf.variable main.tf
2). // Output emily from name_list
3). // Output emily’s score from score_map
4). // Output the length of name_set, to understand the difference between List and Set
5). // Understand auto cast of type, name_list contains true. but it’s changed to the string of “true”. At the same time if you change true to “true” for tuple_example. It still could pass terraform validate
6). // Understand the TYPE check. If you change the true to 123 for tuple_example. It doesn’t pass validate
7). // Transfer params by CLI

 terraform apply -var='name_list=["tom1","emily1"]'

7.Implement and maintain state
Backend Configuration
Partial Configuration
$terraform init \
    -backend-config="address=demo.consul.io" \
    -backend-config="path=example_app/terraform_state" \
    -backend-config="scheme=https"




