variable "repo_name" {
  type    = string
  default = "OneFootball-Hiring/cloud-assignment-hamzeh-shaghlil"
  description = "Repositery Name "
}

variable "branch_name" {
  type    = string
  default = "dev"
  description = "Branch Name"
}

variable "build_project" {
  type    = string
  default = "Go-Project"
  description = "Build Project Name"
}


variable "buildspec" {
  type = string
  default = "buildspec.yml"
  description = "collection of build commands and related settings, in YAML format, that CodeBuild uses to run a build"
}

variable "db_user" {
  type = string
  description = "RDS User"
  
}

variable "db_password" {
  type = string
  description = "RDS Password"

}

variable "port" {
  type = string
  default = 3000
  description = "container port"

}

variable "app" {
  type = string
  default = "go-project"
  description = "Project Name"
}

variable "logs_retention_in_days" {
  type        = number
  default     = 90
  description = "Specifies the number of days you want to retain log events"
}


