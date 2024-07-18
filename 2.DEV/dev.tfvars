PRJ_NAME = "CAL-DEV"
PRJ_VERSION = "1.0"

AWS_PROFILE_NAME="thkim"
AWS_KEY_S3_BUCKET_DIR="ec2key"

AWS_VPC_CIDRs = ["10.10.0.0/16"]
AWS_VPC0_Za_PUB_SN_CIDRs = ["10.10.10.0/24","10.10.50.0/24"]
AWS_VPC0_Za_PRI_SN_CIDRs = ["10.10.100.0/24","10.10.150.0/24"]
AWS_VPC0_Za_INS_IPV4s = ["10.10.10.10"]

# AWS_VPC0_Zb_PUB_SN_CIDRs = ["10.20.0.0/16"]
# AWS_VPC0_Zb_PRI_SN_CIDRs = ["10.20.50.0/24","10.20.100.0/24","10.20.150.0/24"]
# AWS_VPC0_Zb_INS_IPV4s = ["10.20.10.10"]

# AWS_VPC0_Zc_PUB_SN_CIDRs = ["10.30.0.0/16"]
# AWS_VPC0_Zc_PRI_SN_CIDRs = ["10.30.50.0/24","10.30.100.0/24","10.30.150.0/24"]
# AWS_VPC0_Zc_INS_IPV4s = ["10.30.10.10"]

AWS_INS_AMIs = ["ami-0c9c942bd7bf113a2"]
AWS_INS_TYPEs = ["t2.micro"]
AWS_INS_VOL_DIRs = ["/dev/sda1"]
AWS_INS_VOL_SIZEs = [8]
AWS_INS_VOL_TYPEs = ["gp2"]

AWS_INS_UDs_FILEs = [
    [
        "../../4.EC2_USER_DATA/user_data_ubuntu_2204_create_new_user.sh",
        "../../4.EC2_USER_DATA/user_data_ubuntu_2204_avoid_gui_interface.sh",
        "../../4.EC2_USER_DATA/user_data_ubuntu_2204_nat.sh",
        "../../4.EC2_USER_DATA/user_data_ubuntu_2204_package.sh"
    ]
]

SUB_DOMAINs = ["devkops"]
AWS_KOPS_STATE_S3_BUCKET_DIR="devkops-state"