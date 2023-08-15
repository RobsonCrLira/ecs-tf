resource "aws_iam_role" "ecs_role" {
  name = "${var.nameIAM}-ecs-role"

  assume_role_policy = jsondecode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "Service" : ["ecs-tasks.amazonaws.com", "ec2.amazonaws.com"]
        },
        "Effect" : "Allow",
        "Sid" : ""
      }
    ]
  })
}

resource "aws_iam_role_policy" "ecs_role_policy" {
  name = "${var.nameIAM}-ecs-role-policy"
  role = aws_iam_role.ecs_role.name
  policy = jsondecode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" = [
          "ecr:GetAuthoziationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        "Effect" : "Allow",
        "Resource" : "*"
      }
    ]
  })
}

resource "aws_iam_instance_profile" "ecs_instance_profile" {
  name = "${var.nameIAM}-ecs-instance-profile"
  role = aws_iam_role.ecs_role.name
}