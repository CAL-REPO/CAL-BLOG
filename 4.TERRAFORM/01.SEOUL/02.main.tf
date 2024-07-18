module "AWS_REG1_KEY" {
    source = "git::https://github.com/CAL-REPO/TERRAFORM-AWS-EC2KEY.git?ref=2.0"
    providers = {
        aws = aws.Seoul
    }

    PROFILE = local.AWS_PROFILEs[0].NAME
    KEYs = local.AWS_REG1_KEYs
}

module "AWS_REG1_VPC1" {
    source = "git::https://github.com/CAL-REPO/TERRAFORM-AWS-VPC.git?ref=2.0"
    providers = {
        aws = aws.Seoul
    }

    PROFILE = local.AWS_PROFILEs[0].NAME
    VPC = local.AWS_REG1_VPC1
    RTBs = local.AWS_REG1_VPC1_RTBs
    SGs = local.AWS_REG1_VPC1_SGs
}

module "AWS_REG1_CONNECTION" {
    source = "git::https://github.com/CAL-REPO/TERRAFORM-AWS-CONNECTION.git?ref=2.0"
    providers = {
        aws = aws.Seoul
    }

    PROFILE = local.AWS_PROFILEs[0].NAME
    IGW = local.AWS_REG1_IGW
}

module "AWS_REG1_VPC1_INS" {
    source = "git::https://github.com/CAL-REPO/TERRAFORM-AWS-EC2INS.git?ref=2.0"
    providers = {
        aws = aws.Seoul
    }

    PROFILE = local.AWS_PROFILEs[0].NAME
    INSs = local.AWS_REG1_VPC1_INSs
    INS_UDs = local.AWS_REG1_VPC1_INS_UDs
}

module "AWS_REG1_ADD" {
    source = "git::https://github.com/CAL-REPO/TERRAFORM-AWS-ADD.git?ref=2.0"
    providers = {
        aws = aws.Seoul
    }

    PROFILE = local.AWS_PROFILEs[0].NAME
    EIPs = local.AWS_REG1_EIPs
}

module "AWS_GLOBAL_SERVICE" {
    source = "git::https://github.com/CAL-REPO/TERRAFORM-AWS-SERVICE.git?ref=2.0"
    providers = {
        aws = aws.Seoul
    }

    PROFILE = local.AWS_PROFILEs[0].NAME
    RT53_ZONE = local.AWS_KOPS_RT53_ZONEs
}

module "CF_ADD_RECORD" {
    source = "git::https://github.com/CAL-REPO/TERRAFORM-CF-RECORD.git?ref=1.0"

    RECORDs = local.CF_RECORDs
}

module "REMOTE_EXECUTE_ANSIBLE" {
    source = "git::https://github.com/CAL-REPO/TERRAFORM-NULL-REMOTE.git?ref=1.0"
    depends_on = [ module.AWS_REG1_VPC1_INS ]

    providers = {
        aws = aws.Seoul
    }

    PROFILE = local.AWS_PROFILEs[0].NAME
    LOCAL_HOST_PRI_KEY_FILE = local.RUNNER_HOST.PRI_KEY_FILE
    REMOTE_HOST = local.REMOTE_HOST_OPS
    REMOTE_PRE_EXECUTEs = local.REMOTE_PRE_EXECUTEs_FOR_OPS
    REMOTE_SEND_FILEs = local.REMOTE_SEND_FILEs_FOR_OPS
}

module "LOCAL_EXECUTE_SCRIPT_ANSIBLE" {
    source = "git::https://github.com/CAL-REPO/TERRAFORM-NULL-LOCAL.git?ref=1.0"
    depends_on = [ module.REMOTE_EXECUTE_ANSIBLE ]

    PROFILE = local.AWS_PROFILEs[0].NAME
    APPLY_SCRIPTs = local.LOCAL_EXECUTE_APPLY_SCRIPT_ANSIBLE
}

