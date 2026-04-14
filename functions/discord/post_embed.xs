function "discord/post_embed" {
  description = "Post a rich embed (title + description) to a Discord channel via webhook."
  input {
    text webhook_url filters=trim
    text title filters=trim
    text description filters=trim
    text url? filters=trim
    int color?=3447003 filters=min:0|max:16777215
  }
  stack {
    var $embed { value = {
      title: $input.title,
      description: $input.description,
      color: $input.color
    }}
    conditional {
      if ($input.url != null) {
        var.update $embed { value = $embed|set:"url":$input.url }
      }
    }
    api.request {
      url = $input.webhook_url
      method = "POST"
      params = { embeds: [$embed] }
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
