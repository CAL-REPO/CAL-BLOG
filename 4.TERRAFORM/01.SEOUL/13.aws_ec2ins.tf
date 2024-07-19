# REG1
locals {
    AWS_REG1_VPC1_INSs = [
        {
            NAME = "${var.PRJ_NAME}-NAT-BASTION"
            KEY_NAME = module.AWS_REG1_KEY.KEY_NAME[0]
            AMI = "${var.AWS_INS_AMIs[0]}"
            TYPE = "${var.AWS_INS_TYPEs[0]}"
            AUTO_PUBLIC_IP = false
            SRC_DEST_CHECK = false
            SN_ID = module.AWS_REG1_VPC1.Za_SNs_ID[0]
            SG_IDs = [module.AWS_REG1_VPC1.SG_ID[0]]
            PRI_IPV4s = ["${var.AWS_VPC0_Za_INS_IPV4s[0]}"]
            VOL_DIR = "${var.AWS_INS_VOL_DIRs[0]}"
            VOL_SIZE = "${var.AWS_INS_VOL_SIZEs[0]}"
            VOL_TYPE = "${var.AWS_INS_VOL_TYPEs[0]}"
        }
    ]

    AWS_REG1_VPC1_INS_UDs = {
        PRE_SCRIPT= [
            <<-EOF
                export NEW_USER_NAME=${var.OPS_USER_NAME}
                export NEW_USER_PW=${var.OPS_USER_PW}
            EOF
        ]
        FILEs = ["${var.AWS_INS_UDs_FILEs[0]}"]
    }
}