use Mix.Config

config :logger,
  backends: [:console]

config :logger, :console,
  format: "$date $time $metadata[$level] $message\n\n",
  level: :info,
  metadata: [:request_id]

import_config "#{Mix.env()}.exs"
