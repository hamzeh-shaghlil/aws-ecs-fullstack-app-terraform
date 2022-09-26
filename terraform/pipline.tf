 # CODEBUILD
resource "aws_codebuild_project" "repo-project" {
  name         = "${var.build_project}"
  service_role = "${aws_iam_role.codebuild-role.arn}"

   source {
    buildspec = "${var.buildspec}"
    type      = "CODEPIPELINE"
  }

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/standard:5.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = true

    environment_variable {
      name  = "PORT"
      value = var.port
    }
  }
}
# S3 BUCKET FOR ARTIFACTORY_STORE
resource "aws_s3_bucket" "bucket-artifact" {
  bucket = "hamzehsssssss"
  force_destroy = true
}

resource "aws_s3_bucket_acl" "example_bucket_acl" {
  bucket = aws_s3_bucket.bucket-artifact.id
  acl    = "private"
}


resource "aws_codestarconnections_connection" "qureos-prod" {
  name          = "github-connection"
  provider_type = "GitHub"
} 




# CODEPIPELINE
resource "aws_codepipeline" "pipeline" {
  name     = "pipeline"
  role_arn = aws_iam_role.pipeline_role.arn

  artifact_store {
    location = "${aws_s3_bucket.bucket-artifact.bucket}"
    type     = "S3"
  }


  # SOURCE
 
stage {

    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        ConnectionArn = aws_codestarconnections_connection.qureos-prod.arn
        #FullRepositoryId = format("%s/%s", var.github_user, var.repo_name)
        FullRepositoryId = var.repo_name
        BranchName       = var.branch_name
      }
    }
  }









  # BUILD
  stage {
    name = "Build"
    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]

      configuration = {
        ProjectName = "${var.build_project}"
      }
    }
  }
  # DEPLOY
  stage {
    name = "Deploy"
    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ECS"
      version         = "1"
      input_artifacts = ["build_output"]

      configuration = {
        ClusterName = "clusterDev"
        ServiceName = "golang-Service"
        FileName    = "imagedefinitions.json"
      }
    }
  }
}