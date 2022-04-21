variable "vault_addr" {
  default = "placeholder"
}

resource "local_file" "foo" {
  content  = "foo!bar"
  filename = "${path.module}/foo.bar"
}
