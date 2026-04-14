function "discord/post_message" {
  description = "Post a text message to a Discord channel via an incoming webhook URL."
  input {
    text webhook_url filters=trim
    text content filters=trim
    text username? filters=trim
    text avatar_url? filters=trim
  }
  stack {
    var $body { value = { content: $input.content } }
    conditional {
      if ($input.username != null) {
        var.update $body { value = $body|set:"username":$input.username }
      }
    }
    conditional {
      if ($input.avatar_url != null) {
        var.update $body { value = $body|set:"avatar_url":$input.avatar_url }
      }
    }
    api.request {
      url = $input.webhook_url
      method = "POST"
      params = $body
      headers = ["Content-Type: application/json"]
      timeout = 15
    } as $api_result
    precondition ($api_result.response.status >= 200 && $api_result.response.status < 300) {
      error_type = "standard"
      error = "Discord webhook request failed"
    }
  }
  response = { success: true, status: $api_result.response.status }
}
