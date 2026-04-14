resource "aws_cloudwatch_log_group" "main" {
  for_each = local.checks
  name = "/aws/lambda/${local.name_prefix}-${each.key}"
  retention_in_days = 7
  tags = local.common_tags
}


data "archive_file" "main" {
  for_each = local.checks
  type = "zip"
  source_dir = "${local.lambda_source_base}/${each.key}"
  output_path = "${path.module}/build/${each.key}.zip"
}


resource "aws_lambda_function" "main" {
  for_each = local.checks
  function_name = "${local.name_prefix}-${each.key}"
  role          = aws_iam_role.lambda_role.arn
  handler       = "app.lambda_handler"
  runtime       = "python3.12"
  timeout       = each.value.timeout

  filename         = data.archive_file.main[each.key].output_path
  source_code_hash = data.archive_file.main[each.key].output_base64sha256

  environment {
    variables = each.value.environment
  }

  depends_on = [aws_cloudwatch_log_group.main]
  tags       = local.common_tags
}



resource "aws_lambda_layer_version" "pymysql" {
  filename   = "pymysql-layer.zip"
  layer_name = "pymysql-layer"

  compatible_runtimes = ["python3.12"]
}


layers = [aws_lambda_layer_version.pymysql.arn]
