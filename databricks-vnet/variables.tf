variable "spokecidr" {
  type    = string
  default = "10.179.0.0/20"
}

variable "sqlvnetcidr" {
  type    = string
  default = "10.178.0.0/20"
}

variable "no_public_ip" {
  type    = bool
  default = true
}

variable "rglocation" {
  type    = string
  default = "australiaeast"
}

variable "dbfs_prefix" {
  type    = string
  default = "dbfs"
}

variable "workspace_prefix" {
  type    = string
  default = "adb"
}