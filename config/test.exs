use Mix.Config

config :logger, :console,
  format: "$time $metadata[$level] $message\n\n",
  level: :debug
