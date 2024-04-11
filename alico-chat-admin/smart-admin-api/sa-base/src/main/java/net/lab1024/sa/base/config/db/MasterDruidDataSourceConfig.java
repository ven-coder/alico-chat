package net.lab1024.sa.base.config.db;

import com.alibaba.druid.filter.Filter;
import com.alibaba.druid.pool.DruidDataSource;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.autoconfigure.AutoConfigureBefore;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.sql.SQLException;
import java.util.ArrayList;

/**
 * [ 数据源配置 ]
 *
 * @author zhuoda
 */
@Configuration
@AutoConfigureBefore(SmartDbConfig.class)
public class MasterDruidDataSourceConfig {

    @Value("${spring.master.datasource.driver-class-name}")
    private String driver;

    @Value("${spring.master.datasource.url}")
    private String url;

    @Value("${spring.master.datasource.username}")
    private String username;

    @Value("${spring.master.datasource.password}")
    private String password;

    @Value("${spring.master.datasource.initial-size}")
    private Integer initialSize;

    @Value("${spring.master.datasource.min-idle}")
    private Integer minIdle;

    @Value("${spring.master.datasource.max-active}")
    private Integer maxActive;

    @Value("${spring.master.datasource.max-wait}")
    private Long maxWait;

    @Value("${spring.master.datasource.time-between-eviction-runs-millis}")
    private Long timeBetweenEvictionRunsMillis;

    @Value("${spring.master.datasource.min-evictable-edle-time-millis}")
    private Long minEvictableIdleTimeMillis;

    @Value("${spring.master.datasource.filters}")
    private String filters;

    @Bean(name = "masterDataSource")
    public DruidDataSource druidDataSource() throws SQLException {
        DruidDataSource druidDataSource = new DruidDataSource();
        druidDataSource.setDriverClassName(driver);
        druidDataSource.setUrl(url);
        druidDataSource.setUsername(username);
        druidDataSource.setPassword(password);
        druidDataSource.setInitialSize(initialSize);
        druidDataSource.setMinIdle(minIdle);
        druidDataSource.setMaxActive(maxActive);
        druidDataSource.setMaxWait(maxWait);
        druidDataSource.setTimeBetweenEvictionRunsMillis(timeBetweenEvictionRunsMillis);
        druidDataSource.setMinEvictableIdleTimeMillis(minEvictableIdleTimeMillis);
        druidDataSource.setValidationQuery("SELECT 1 FROM dual");
        druidDataSource.setFilters(filters);
        ArrayList<Filter> arrayList = new ArrayList<>();
        druidDataSource.setProxyFilters(arrayList);
        druidDataSource.init();
        return druidDataSource;
    }

}
