use Mix.Config

config :logger, :console,
  format: "$date $time $metadata[$level] $message\n\n",
  level: :warn,
  metadata: [:request_id]
