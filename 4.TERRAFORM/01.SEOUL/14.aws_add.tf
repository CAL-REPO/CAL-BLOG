# REG1
locals {
    AWS_REG1_EIPs = [
        {
            NAME = "${var.PRJ_NAME}-NAT-BASTION"
            INS_ID = "${module.AWS_REG1_VPC1_INS.ID[0]}"
        }
    ]
}