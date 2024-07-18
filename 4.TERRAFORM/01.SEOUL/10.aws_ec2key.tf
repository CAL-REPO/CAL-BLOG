# REG1
locals {
    AWS_REG1_KEYs = [
        {
            NAME = "${var.PRJ_NAME}-AWS-${local.AWS_PROFILEs[0].NAME}"
            ALGORITHM = "RSA"
            RSA_SIZE = 4096
            FILE_TYPE = "pem"
            LINUX_DIR = ""
            WIN_DIR = ""
            RUNNER_DIR = "/home/runner"
            S3_DIR = "${var.AWS_KEY_S3_BUCKET_NAME}/${var.AWS_KEY_S3_BUCKET_DIR}"
        }
    ]
}