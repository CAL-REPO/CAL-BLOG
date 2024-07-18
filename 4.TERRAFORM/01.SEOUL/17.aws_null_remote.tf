locals {

    RUNNER_HOST = {
        USER = "runner"
        USER_DIR = "${local.AWS_REG1_KEYs[0].RUNNER_DIR}"
        PRI_KEY_FILE = "${module.AWS_REG1_KEY.KEY_PRI_RUNNER_FILE[0]}"
    }

    REMOTE_HOST_OPS = {
        USER = "${var.OPS_USER_NAME}"
        USER_DIR = "/home/${var.OPS_USER_NAME}"
        EXTERNAL_IP = "${module.AWS_REG1_ADD.EIP_IP[0]}"
        SSH_DIR = "/home/${var.OPS_USER_NAME}/.ssh"
        AWS_DIR = "/home/${var.OPS_USER_NAME}/.aws"
        GIT_DIR = "/home/${var.OPS_USER_NAME}/infra"
        K8S_DIR = "/home/${var.OPS_USER_NAME}/infra/kops"
        KOPS_PRI_KEY_FILE_NAME = "${module.AWS_REG1_KEY.KEY_PRI_FILE_NAME[0]}"
    }

    REMOTE_PRE_EXECUTEs_FOR_OPS= [
        {
            ALWAYS = false
            COMMANDs = [
                "mkdir -p ${local.REMOTE_HOST_OPS.AWS_DIR}",
                "mkdir -p ${local.REMOTE_HOST_OPS.GIT_DIR}",
                "mkdir -p ${local.REMOTE_HOST_OPS.K8S_DIR}",
                "if [ -f ${local.REMOTE_HOST_OPS.SSH_DIR}/${local.REMOTE_HOST_OPS.KOPS_PRI_KEY_FILE_NAME} ]; then",
                "  sudo rm -rf ${local.REMOTE_HOST_OPS.SSH_DIR}/${local.REMOTE_HOST_OPS.KOPS_PRI_KEY_FILE_NAME}",
                "fi"
            ]
        }
    ]

    REMOTE_SEND_FILEs_FOR_OPS= [
        {
            ALWAYS = false
            SOURCE = "${local.RUNNER_HOST.USER_DIR}/.aws/config"
            DESTINATION = "${local.REMOTE_HOST_OPS.USER_DIR}/.aws/config"
            COMMANDs = ["sudo chmod 644 ${local.REMOTE_HOST_OPS.USER_DIR}/.aws/config"]
        }
        ,{
            ALWAYS = false
            SOURCE = "${local.RUNNER_HOST.USER_DIR}/.aws/credentials"
            DESTINATION = "${local.REMOTE_HOST_OPS.USER_DIR}/.aws/credentials"
            COMMANDs = ["sudo chmod 644 ${local.REMOTE_HOST_OPS.USER_DIR}/.aws/credentials"]
        }
        ,{
            ALWAYS = false
            SOURCE = "${local.RUNNER_HOST.PRI_KEY_FILE}"
            DESTINATION = "${local.REMOTE_HOST_OPS.SSH_DIR}/${local.REMOTE_HOST_OPS.KOPS_PRI_KEY_FILE_NAME}"
            COMMANDs = ["sudo chmod 400 ${local.REMOTE_HOST_OPS.SSH_DIR}/${local.REMOTE_HOST_OPS.KOPS_PRI_KEY_FILE_NAME}"]
        }
    ]

}