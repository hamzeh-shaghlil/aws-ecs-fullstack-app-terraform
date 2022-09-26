 
module "cluster" {
  source  = "terraform-aws-modules/rds-aurora/aws"
  version = "7.2.1"

  name           = "go-db"
  engine         = "aurora-mysql"
  engine_version = "5.7.mysql_aurora.2.10.2"
  instance_class = "db.t3.small"
  instances = {
     one = {}
    2 = {
      instance_class = "db.t3.small"
    }
  }

  vpc_id  = "${aws_vpc.ecs-vpc.id}"
  subnets =  ["${aws_subnet.private-subnets[0].id}", "${aws_subnet.private-subnets[1].id}"]

  allowed_security_groups = ["${aws_security_group.ecs-sg.id}"]
 

  storage_encrypted   = true
  apply_immediately   = true
  monitoring_interval = 10
  database_name           = "dev"
  master_username         = var.db_user
  master_password         = var.db_password
  create_random_password = false

  
}


 


 