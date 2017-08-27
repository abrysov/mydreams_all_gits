RedisClient = Redis::Namespace.new(
  Dreams.config.redis.namespace,
  redis: Redis.new(
    password: Dreams.config.redis.password,
    host: Dreams.config.redis.host,
    port: Dreams.config.redis.port,
    db: Dreams.config.redis.db
  )
)
