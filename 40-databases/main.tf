# ------------------- MONGODB -------------------

resource "aws_instance" "mongodb" {
  ami           = local.ami_id
  instance_type = "t3.micro"

  subnet_id = local.public_subnet_id              # ✅ FIX
  associate_public_ip_address = true              # ✅ ADD

  vpc_security_group_ids = [local.mongodb_sg_id]

  tags = merge(
    {
      Name = "${var.project}-${var.environment}-mongodb"
    },
    local.common_tags
  )
}

resource "terraform_data" "mongodb" {
  triggers_replace = [
    aws_instance.mongodb.id
  ]

  connection {
    type     = "ssh"
    user     = "ec2-user"
    password = "DevOps321"
    host     = aws_instance.mongodb.public_ip     # ✅ FIX
  }

  provisioner "file" {
    source      = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/bootstrap.sh",
      "sudo sh /tmp/bootstrap.sh mongodb ${var.environment}"
    ]
  }
}

# ------------------- REDIS -------------------

resource "aws_instance" "redis" {
  ami           = local.ami_id
  instance_type = "t3.micro"

  subnet_id = local.public_subnet_id
  associate_public_ip_address = true

  vpc_security_group_ids = [local.redis_sg_id]

  tags = merge(
    {
      Name = "${var.project}-${var.environment}-redis"
    },
    local.common_tags
  )
}

resource "terraform_data" "bootstrap_redis" {
  triggers_replace = [
    aws_instance.redis.id
  ]

  connection {
    type     = "ssh"
    user     = "ec2-user"
    password = "DevOps321"
    host     = aws_instance.redis.public_ip       # ✅ FIX
  }

  provisioner "file" {
    source      = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/bootstrap.sh",
      "sudo sh /tmp/bootstrap.sh redis ${var.environment}"
    ]
  }
}

# ------------------- MYSQL -------------------

resource "aws_instance" "mysql" {
  ami           = local.ami_id
  instance_type = "t3.micro"

  subnet_id = local.public_subnet_id
  associate_public_ip_address = true

  vpc_security_group_ids = [local.mysql_sg_id]
  iam_instance_profile   = aws_iam_instance_profile.mysql.name

  tags = merge(
    {
      Name = "${var.project}-${var.environment}-mysql"
    },
    local.common_tags
  )
}

resource "terraform_data" "mysql" {
  triggers_replace = [
    aws_instance.mysql.id
  ]

  connection {
    type     = "ssh"
    user     = "ec2-user"
    password = "DevOps321"
    host     = aws_instance.mysql.public_ip       # ✅ FIX
  }

  provisioner "file" {
    source      = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/bootstrap.sh",
      "sudo sh /tmp/bootstrap.sh mysql ${var.environment}"
    ]
  }
}

# ------------------- RABBITMQ -------------------

resource "aws_instance" "rabbitmq" {
  ami           = local.ami_id
  instance_type = "t3.micro"

  subnet_id = local.public_subnet_id
  associate_public_ip_address = true

  vpc_security_group_ids = [local.rabbitmq_sg_id]

  tags = merge(
    {
      Name = "${var.project}-${var.environment}-rabbitmq"
    },
    local.common_tags
  )
}

resource "terraform_data" "rabbitmq" {
  triggers_replace = [
    aws_instance.rabbitmq.id
  ]

  connection {
    type     = "ssh"
    user     = "ec2-user"
    password = "DevOps321"
    host     = aws_instance.rabbitmq.public_ip   # ✅ FIX
  }

  provisioner "file" {
    source      = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/bootstrap.sh",
      "sudo sh /tmp/bootstrap.sh rabbitmq ${var.environment}"
    ]
  }
}