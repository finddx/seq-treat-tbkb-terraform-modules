resource "aws_glue_classifier" "this" {
  for_each = var.glue_classifier
  name     = each.key
  csv_classifier {
    allow_single_column    = lookup(each.value, "allow_single_column", false)
    contains_header        = lookup(each.value, "contains_header", "ABSENT")
    delimiter              = lookup(each.value, "delimiter", "\t")
    disable_value_trimming = lookup(each.value, "disable_value_trimming", false)
    header                 = lookup(each.value, "header", [])
    quote_symbol           = lookup(each.value, "quote_symbol", "\"")
  }
}
