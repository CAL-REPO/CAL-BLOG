# REG1
locals {
    AWS_REG1_IGW = [
        {
            NAME = "${var.PRJ_NAME}-IGW"
            VPC_ID = "${module.AWS_REG1_VPC1.VPC_ID}"
        }
    ]
}