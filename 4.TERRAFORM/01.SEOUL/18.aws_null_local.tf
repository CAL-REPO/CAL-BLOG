locals {

    LOCAL_EXECUTE_VAR = {
        ANSIBLE_CONF_FILE_PATH = "../../5.ANSIBLE/0.CONFIG/ansible.cfg"
        ANSIBLE_HOST_FILE_PATH = "../../5.ANSIBLE/0.CONFIG/hosts"
        ANSIBLE_PLAYBOOK_APPLY_DIR_PATH = "../../5.ANSIBLE/1.PLAYBOOK_APPLY"
        ANSIBLE_PLAYBOOK_DESTROY_DIR_PATH = "../../5.ANSIBLE/2.PLAYBOOK_DESTROY"
        ANSIBLE_HOST_GROUP = "bastion"
        GIT_USER_NAME = "${var.OPS_GIT_USER_NAME}"
        GIT_USER_EMAIL = "${var.OPS_GIT_USER_EMAIL}"
        GIT_LOCAL_REMOTE_NAME = "CAL-OPS"
        GIT_REPO_URL = "${var.OPS_GIT_REPO_URL}"
        GIT_REPO_AUTH_URL = "${var.OPS_GIT_REPO_AUTH_URL}"
        GIT_COMMIT_MESSAGE = "Commited by infra manager"
        GIT_BRANCH_NAME = "initial"
        KOPS_STATE_S3_BUCKET = "${var.AWS_KOPS_STATE_S3_BUCKET}"
        KOPS_STATE_S3_DIR = "${var.AWS_KOPS_STATE_S3_BUCKET_DIR}"
    }

    LOCAL_EXECUTE_APPLY_SCRIPT_ANSIBLE = [
        {
            ALWAYS = true
            PRE_COMMAND = <<-EOF
            cat <<-EOT > "${local.LOCAL_EXECUTE_VAR.ANSIBLE_CONF_FILE_PATH}"
            [defaults]
            EOT
            cat <<-EOT > "${local.LOCAL_EXECUTE_VAR.ANSIBLE_HOST_FILE_PATH}"
            [${local.LOCAL_EXECUTE_VAR.ANSIBLE_HOST_GROUP}]
            ${module.AWS_REG1_ADD.EIP_IP[0]} ansible_user="${var.OPS_USER_NAME}" ansible_ssh_private_key_file="${module.AWS_REG1_KEY.KEY_PRI_RUNNER_FILE[0]}"
            [${local.LOCAL_EXECUTE_VAR.ANSIBLE_HOST_GROUP}:vars]
            MAIN_DOMAIN="${var.CF_DOMAIN_MAIN}"
            AWS_PAGER=""
            AWS_PROFILE="${local.AWS_PROFILEs[0].NAME}"
            GIT_USER_NAME="${local.LOCAL_EXECUTE_VAR.GIT_USER_NAME}"
            GIT_USER_EMAIL="${local.LOCAL_EXECUTE_VAR.GIT_USER_EMAIL}"
            GIT_LOCAL_DIR="${local.REMOTE_HOST_OPS.GIT_DIR}"
            GIT_LOCAL_REMOTE_NAME="${local.LOCAL_EXECUTE_VAR.GIT_LOCAL_REMOTE_NAME}"
            GIT_REPO_URL="${local.LOCAL_EXECUTE_VAR.GIT_REPO_URL}"
            GIT_REPO_AUTH_URL="${local.LOCAL_EXECUTE_VAR.GIT_REPO_AUTH_URL}"
            GIT_COMMIT_MESSAGE="${local.LOCAL_EXECUTE_VAR.GIT_COMMIT_MESSAGE}"
            GIT_BRANCH_NAME="${local.LOCAL_EXECUTE_VAR.GIT_BRANCH_NAME}"
            KOPS_DIR="${local.REMOTE_HOST_OPS.K8S_DIR}"
            KOPS_STATE_S3_BUCKET="${local.LOCAL_EXECUTE_VAR.KOPS_STATE_S3_BUCKET}"
            KOPS_STATE_S3_DIR="${local.LOCAL_EXECUTE_VAR.KOPS_STATE_S3_DIR}"
            KOPS_STATE_S3="s3://${local.LOCAL_EXECUTE_VAR.KOPS_STATE_S3_BUCKET}/${local.LOCAL_EXECUTE_VAR.KOPS_STATE_S3_DIR}"
            KOPS_CLUSTER_NAME="${var.SUB_DOMAINs[0]}.${var.CF_DOMAIN_MAIN}"
            KOPS_CLUSTER_USER_NAME="${var.SUB_DOMAINs[0]}"
            KOPS_CLUSTER_VERSION="v1.27.3"
            KOPS_CLUSTER_CONTAINER_RUNTIME="containerd"
            KOPS_CLUSTER_CLOUD="aws"
            KOPS_CLUSTER_API_PUBLIC_NAME="${var.SUB_DOMAINs[0]}.${var.CF_DOMAIN_MAIN}"
            KOPS_CLUSTER_TOPOLOGY="private"
            KOPS_CLUSTER_NETWORK="calico"
            KOPS_CLUSTER_NETWORK_ID="${module.AWS_REG1_VPC1.VPC_ID}"
            KOPS_CLUSTER_LB_TYPE="internal"
            KOPS_CLUSTER_LB_CLASS="network"
            KOPS_CLUSTER_ZONES="${local.AWS_REGIONs[0].CODE}a"
            KOPS_CLUSTER_MASTER_ZONES="${local.AWS_REGIONs[0].CODE}a"
            KOPS_CLUSTER_MASTER_SIZE="t3.medium"
            KOPS_CLUSTER_NODE_SIZE="t3.medium"
            KOPS_CLUSTER_NODE_COUNT=1
            KOPS_CLUSTER_UTILITY_SUBNETS="${module.AWS_REG1_VPC1.Za_SNs_ID[1]}"
            KOPS_CLUSTER_SUBNETS="${module.AWS_REG1_VPC1.Za_SNs_ID[2]}"
            KOPS_CLUSTER_BASTION_CIDR="${var.AWS_VPC0_Za_PUB_SN_CIDRs[0]}"
            KOPS_CLUSTER_SSH_PUBLIC_KEY_FILE="/home/${var.OPS_USER_NAME}/.ssh/authorized_keys"
            EOT
            EOF
            POST_COMMAND = <<-EOF
            export CONFIG_FILE_PATH="${local.LOCAL_EXECUTE_VAR.ANSIBLE_CONF_FILE_PATH}"
            export INVENTORY_FILE_PATH="${local.LOCAL_EXECUTE_VAR.ANSIBLE_HOST_FILE_PATH}"
            export PLAYBOOK_DIR="${local.LOCAL_EXECUTE_VAR.ANSIBLE_PLAYBOOK_APPLY_DIR_PATH}"
            export HOST_GROUP="${local.LOCAL_EXECUTE_VAR.ANSIBLE_HOST_GROUP}"
            bash "../2.WORKFLOWS_SCRIPT/execute_ansible_playbook.sh"
            EOF
        }
    ]
}