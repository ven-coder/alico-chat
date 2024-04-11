package net.lab1024.sa.base.config.db;

import com.alibaba.druid.pool.DruidDataSource;
import com.google.common.base.CaseFormat;
import net.lab1024.smartdb.SmartDb;
import net.lab1024.smartdb.SmartDbBuilder;
import net.lab1024.smartdb.database.SupportDatabaseType;
import net.lab1024.smartdb.ext.SmartDbExtEnum;
import net.lab1024.smartdb.filter.impl.SqlExecutorTimeFilter;
import net.lab1024.smartdb.sqlbuilder.convertor.CaseFormatColumnNameConverter;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import javax.annotation.Resource;

/**
 * smart db 配置
 *
 * @author zhuoda
 */
@Configuration
public class SmartDbConfig {

    @Resource(name = "masterDataSource")
    private DruidDataSource master;

    @Resource(name = "slaveDataSource")
    private DruidDataSource slave;

    @Resource(name = "thirdDataSource")
    private DruidDataSource third;

    @Bean("default")
    public SmartDb initSmartDb() {
        SmartDb smartDb = SmartDbBuilder.create()
                // 设置 主库 （写库）
                .setMasterDataSource(master)
                // 设置 从库 （读库）
                .setSlaveDataSource(slave)
                // 打印 info 级别sql
                .setShowSql(true)
                // 设置数据库类型
                .setSupportDatabaseType(SupportDatabaseType.MYSQL)
                // 设置支持spring 5
                .setSmartDbExtEnum(SmartDbExtEnum.SPRING5)
                //表名与类名转换
                .setTableNameConverter(cls -> "t_" + CaseFormat.UPPER_CAMEL.to(CaseFormat.LOWER_UNDERSCORE, cls.getSimpleName()))
                //列名字 转换
                .setColumnNameConverter(new CaseFormatColumnNameConverter(CaseFormat.LOWER_CAMEL, CaseFormat.LOWER_UNDERSCORE))
                //添加 sql 执行时间的 debug 信息filter
                .addSmartDbFilter(new SqlExecutorTimeFilter())
                .build();
        return smartDb;
    }

    @Bean(name = "third")
    public SmartDb initThirdSmartDb() {
        SmartDb smartDb = SmartDbBuilder.create()
                // 设置 主库 （写库）
                .setMasterDataSource(third)
                // 打印 info 级别sql
                .setShowSql(true)
                // 设置数据库类型
                .setSupportDatabaseType(SupportDatabaseType.MYSQL)
                // 设置支持spring 5
                .setSmartDbExtEnum(SmartDbExtEnum.SPRING5)
                //表名与类名转换
                .setTableNameConverter(cls -> "t_" + CaseFormat.UPPER_CAMEL.to(CaseFormat.LOWER_UNDERSCORE, cls.getSimpleName()))
                //列名字 转换
                .setColumnNameConverter(new CaseFormatColumnNameConverter(CaseFormat.LOWER_CAMEL, CaseFormat.LOWER_UNDERSCORE))
                //添加 sql 执行时间的 debug 信息filter
                .addSmartDbFilter(new SqlExecutorTimeFilter())
                .build();
        return smartDb;
    }

}
