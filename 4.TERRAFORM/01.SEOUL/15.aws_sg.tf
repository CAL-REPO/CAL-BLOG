# SG Rule List
locals {
    SG_ALL_ALL = {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        description = "All traffic"
    }
    SG_ICMP_ALL = {
        from_port   = -1
        to_port     = -1
        protocol    = "icmp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Ping"
    }
    SG_SSH_ALL = {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "SSH"        
    }
    SG_SSH_FROM_BASTION = {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "SSH"    
    }
    SG_HTTP_ALL = {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "HTTP"
    }
    SG_HTTPS_ALL = {
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "HTTPS"
    }
    SG_DB_ALL = {
        from_port   = 3306
        to_port     = 3306
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "DB"
    }
    SG_DNS_TCP = {
        from_port   = 53
        to_port     = 53
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "DNS" 
    }
    SG_DNS_UDP = {
        from_port   = 53
        to_port     = 53
        protocol    = "udp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "DNS"
    }
    # SG_VPN_500 = {
    #     from_port   = 500
    #     to_port     = 500
    #     protocol    = "udp"
    #     cidr_blocks = ["0.0.0.0/0"]
    #     description = "VPN"
    # }
    # SG_VPN_4500 = {
    #     from_port   = 4500
    #     to_port     = 4500
    #     protocol    = "udp"
    #     cidr_blocks = ["0.0.0.0/0"]
    #     description = "VPN"
    # }
    # SG_K8S_ETCD_API = {
    #     from_port   = 2379
    #     to_port     = 2380
    #     protocol    = "tcp"
    #     cidr_blocks = ["0.0.0.0/0"]
    #     description = "K8S_MASTER"
    # }    
    # SG_K8S_API = {
    #     from_port   = 6443
    #     to_port     = 6443
    #     protocol    = "tcp"
    #     cidr_blocks = ["0.0.0.0/0"]
    #     description = "K8S_MASTER"
    # }
    # SG_K8S_CONTROLLER = {
    #     from_port   = 10257
    #     to_port     = 10257
    #     protocol    = "tcp"
    #     cidr_blocks = ["0.0.0.0/0"]
    #     description = "K8S_MASTER"
    # }    
    # SG_K8S_SCHEDULER = {
    #     from_port   = 10259
    #     to_port     = 10259
    #     protocol    = "tcp"
    #     cidr_blocks = ["0.0.0.0/0"]
    #     description = "K8S_MASTER"
    # }
    # SG_K8S_NODE = {
    #     from_port   = 30000
    #     to_port     = 32767
    #     protocol    = "tcp"
    #     cidr_blocks = ["0.0.0.0/0"]
    #     description = "K8S_WORKER"
    # }
    # SG_K8S_KUBELET_API = {
    #     from_port   = 10250
    #     to_port     = 10250
    #     protocol    = "tcp"
    #     cidr_blocks = ["0.0.0.0/0"]
    #     description = "K8S_ALL"
    # }
}

locals {
    AWS_REG1_VPC1_SGs = [
        {
            NAME = "${var.PRJ_NAME}-NAT-BASTION-SG"
            INGRESS = [
                local.SG_SSH_ALL,
                local.SG_HTTP_ALL,
                local.SG_HTTPS_ALL,
                local.SG_ICMP_ALL
            ]
            EGRESS = [
                local.SG_SSH_ALL,
                local.SG_HTTP_ALL,
                local.SG_HTTPS_ALL,
                local.SG_ICMP_ALL
            ]
        }
        ,{
            NAME = "${var.PRJ_NAME}-DB-SG"
            INGRESS = [
                local.SG_SSH_ALL,
                local.SG_DB_ALL,
                local.SG_ICMP_ALL
            ]
            EGRESS = [
                local.SG_SSH_ALL,
                local.SG_DB_ALL,
                local.SG_ICMP_ALL
            ]
        }
        ,{
            NAME = "${var.PRJ_NAME}-APP-SG"
            INGRESS = [
                local.SG_SSH_ALL,
                local.SG_HTTP_ALL,
                local.SG_HTTPS_ALL,
                local.SG_DB_ALL,
                local.SG_ICMP_ALL
            ]
            EGRESS = [
                local.SG_SSH_ALL,
                local.SG_HTTP_ALL,
                local.SG_HTTPS_ALL,
                local.SG_DB_ALL,
                local.SG_ICMP_ALL
            ]
        }
    ]
}