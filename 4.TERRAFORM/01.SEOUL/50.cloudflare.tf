locals {
    CF_RECORDs = [
        {
            DOMAIN = "${var.CF_DOMAIN_MAIN}"
            NAME    = "${var.SUB_DOMAINs[0]}"
            TYPE    = "NS"
            VALUE   = "${module.AWS_GLOBAL_SERVICE.RT53_ZONE_NS[0][0]}"
            TTL     = 3600
        }
        ,{
            DOMAIN = "${var.CF_DOMAIN_MAIN}"
            NAME    = "${var.SUB_DOMAINs[0]}"
            TYPE    = "NS"
            VALUE   = "${module.AWS_GLOBAL_SERVICE.RT53_ZONE_NS[0][1]}"
            TTL     = 3600
        }
        ,{
            DOMAIN = "${var.CF_DOMAIN_MAIN}"
            NAME    = "${var.SUB_DOMAINs[0]}"
            TYPE    = "NS"
            VALUE   = "${module.AWS_GLOBAL_SERVICE.RT53_ZONE_NS[0][2]}"
            TTL     = 3600
        }
        ,{
            DOMAIN = "${var.CF_DOMAIN_MAIN}"
            NAME    = "${var.SUB_DOMAINs[0]}"
            TYPE    = "NS"
            VALUE   = "${module.AWS_GLOBAL_SERVICE.RT53_ZONE_NS[0][3]}"
            TTL     = 3600
        }
    ]
}
