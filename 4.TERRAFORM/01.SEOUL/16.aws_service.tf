# GLOBAL
locals {
    AWS_KOPS_RT53_ZONEs = [
        {  
            NAME = "${var.SUB_DOMAINs[0]}"
            TYPE_PRIVATE = false           
            DOMAIN_NAME = "${var.SUB_DOMAINs[0]}.${var.CF_DOMAIN_MAIN}"
        }
    ]
}