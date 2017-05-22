config = YAML.load_file(File.join(Rails.root, "config", "redis.yml"))[Rails.env.to_s]

Redis.current = Redis::Namespace.new(
  "#{Rails.application.engine_name}:#{Rails.env}",
  redis: Redis.new(
    host:     config["server"],
    port:     config["port"],
    password: config["password"],
    timeout: 10
  )
)
