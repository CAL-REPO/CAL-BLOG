# REG1
locals {
    AWS_REG1_VPC1 = {
        NAME                = "${var.PRJ_NAME}-VPC"
        CIDR                = "${var.AWS_VPC_CIDRs[0]}"
        DNS_SUP             = true
        DNS_HOST            = true
        DHCP_NAME           = ""
        DHCP_DOMAIN         = ""
        DHCP_DOMAIN_NSs     = []
        DHCP_DOMAIN_NTPs    = []
        DHCP_DOMAIN_NBSs    = []
        DHCP_DOMAIN_NODE    = null
        Za_SNs_NAME         = ["${var.PRJ_NAME}-Za-NAT-BASTION", "${var.PRJ_NAME}-Za-PUBLIC", "${var.PRJ_NAME}-Za-DB", "${var.PRJ_NAME}-Za-WEB"]
        Za_SNs_CIDR         = concat(var.AWS_VPC0_Za_PUB_SN_CIDRs, var.AWS_VPC0_Za_PRI_SN_CIDRs)
        Zb_SNs_NAME         = []
        Zb_SNs_CIDR         = concat(var.AWS_VPC0_Zb_PUB_SN_CIDRs, var.AWS_VPC0_Zb_PRI_SN_CIDRs)
        Zc_SNs_NAME         = []
        Zc_SNs_CIDR         = concat(var.AWS_VPC0_Zc_PUB_SN_CIDRs, var.AWS_VPC0_Zc_PRI_SN_CIDRs)
    }
    
    AWS_REG1_VPC1_RTBs = [
        {
            NAME = "${var.PRJ_NAME}-Za-NAT-BASTION"
            SN_ID = "${module.AWS_REG1_VPC1.Za_SNs_ID[0]}"
            ROUTE = [
                {
                    cidr_block = "0.0.0.0/0"
                    gateway_id = module.AWS_REG1_CONNECTION.IGW_ID[0]
                }
            ]
        }
        ,{
            NAME = "${var.PRJ_NAME}-SEOUL-Za-PROXY"
            SN_ID = "${module.AWS_REG1_VPC1.Za_SNs_ID[1]}"
            ROUTE = [
                {
                    cidr_block = "0.0.0.0/0"
                    gateway_id = module.AWS_REG1_CONNECTION.IGW_ID[0]
                }
            ]
        }
        ,{
            NAME = "${var.PRJ_NAME}-SEOUL-Za-DB"
            SN_ID = "${module.AWS_REG1_VPC1.Za_SNs_ID[2]}"
            ROUTE = [
                {
                    cidr_block = "0.0.0.0/0"
                    network_interface_id = module.AWS_REG1_VPC1_INS.DEFAULT_NIC_ID[0]
                }
            ]
        }
        ,{
            NAME = "${var.PRJ_NAME}-SEOUL-Za-WEB"
            SN_ID = "${module.AWS_REG1_VPC1.Za_SNs_ID[3]}"
            ROUTE = [
                {
                    cidr_block = "0.0.0.0/0"
                    network_interface_id = module.AWS_REG1_VPC1_INS.DEFAULT_NIC_ID[0]
                }
            ]
        }
        # ,{
        #     NAME = "${var.PRJ_NAME}-SEOUL-Za-FRONTEND"
        #     SN_ID = "${module.AWS_REG1_VPC1.Za_SNs_ID[4]}"
        #     ROUTE = [
        #         {
        #             cidr_block = "0.0.0.0/0"
        #             network_interface_id = module.AWS_REG1_VPC1_INS.DEFAULT_NIC_ID[0]
        #         }
        #     ]
        # }
        # ,{
        #     NAME = "${var.PRJ_NAME}-SEOUL-Za-BACKEND"
        #     SN_ID = "${module.AWS_REG1_VPC1.Za_SNs_ID[5]}"
        #     ROUTE = [
        #         {
        #             cidr_block = "0.0.0.0/0"
        #             network_interface_id = module.AWS_REG1_VPC1_INS.DEFAULT_NIC_ID[0]
        #         }
        #     ]
        # }
    ]
}