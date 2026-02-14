import io.lettuce.core.RedisURI;
import io.lettuce.core.api.StatefulRedisConnection;

public class RedisClient {
    private io.lettuce.core.RedisClient client;
    private StatefulRedisConnection<String, String> connection;

    private RedisClient(io.lettuce.core.RedisClient client) {
        this.client = client;
    }

    public static RedisClient create(RedisURI redisURI) {
        io.lettuce.core.RedisClient redisClient = io.lettuce.core.RedisClient.create(redisURI);
        return new RedisClient(redisClient);
    }

    public StatefulRedisConnection<String, String> connect() {
        this.connection = client.connect();
        return connection;
    }

    public void shutdown() {
        if (connection != null) {
            connection.close();
        }
        if (client != null) {
            client.shutdown();
        }
    }
}
