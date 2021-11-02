variable "name" {
  type    = string
  default = "seungjun"
}

variable "avazone" {
  type    = list(any)
  default = ["a", "c"]

}
variable "region" {
  type    = string
  default = "ap-northeast-2"
}

variable "key" {
  type    = string
  default = "tf-key"
}

variable "cidr" {
  type    = string
  default = "0.0.0.0/0"
}
variable "cidr_main" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_s" {
  type    = list(any)
  default = ["10.0.0.0/24", "10.0.2.0/24"]
}

variable "private_s" {
  type    = list(any)
  default = ["10.0.1.0/24", "10.0.3.0/24"]
}

variable "db_s" {
  type    = list(any)
  default = ["10.0.4.0/24", "10.0.5.0/24"]
}
variable "private_ip" {
  type    = string
  default = "10.0.0.11"
}




