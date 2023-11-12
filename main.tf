
provider "aws" {
  region = "eu-central-1"
}


resource "aws_appsync_graphql_api" "demoAPI" {
  name                = "demo-esincompatiblejoin-api"
  authentication_type = "API_KEY"

  schema = <<EOF
type Query {
    testUndefined: String @aws_auth
    testNull: String @aws_auth
}
EOF
}

resource "aws_appsync_api_key" "demoAPI" {
  api_id  = aws_appsync_graphql_api.demoAPI.id
  expires = timeadd(timestamp(), "${24 * 354}h")
}

resource "aws_appsync_datasource" "demoNone" {
  name   = "SourceNone"
  type   = "NONE"
  api_id = aws_appsync_graphql_api.demoAPI.id
}

resource "aws_appsync_function" "demoTestUndefined" {
  api_id      = aws_appsync_graphql_api.demoAPI.id
  data_source = aws_appsync_datasource.demoNone.name
  name        = "testUndefined"
  code        = file("${path.module}/query/testUndefined.js")

  runtime {
    name            = "APPSYNC_JS"
    runtime_version = "1.0.0"
  }
}

resource "aws_appsync_resolver" "demoTestUndefined" {
  type              = "Query"
  field             = "testUndefined"
  kind              = "PIPELINE"
  api_id            = aws_appsync_graphql_api.demoAPI.id
  request_template  = "{}"
  response_template = "$util.toJson($ctx.result)"

  pipeline_config {
    functions = [aws_appsync_function.demoTestUndefined.function_id]
  }
}

resource "aws_appsync_function" "demoTestNull" {
  api_id      = aws_appsync_graphql_api.demoAPI.id
  data_source = aws_appsync_datasource.demoNone.name
  name        = "testNull"
  code        = file("${path.module}/query/testNull.js")

  runtime {
    name            = "APPSYNC_JS"
    runtime_version = "1.0.0"
  }
}

resource "aws_appsync_resolver" "demoTestNull" {
  type              = "Query"
  field             = "testNull"
  kind              = "PIPELINE"
  api_id            = aws_appsync_graphql_api.demoAPI.id
  request_template  = "{}"
  response_template = "$util.toJson($ctx.result)"

  pipeline_config {
    functions = [aws_appsync_function.demoTestNull.function_id]
  }
}
