/*
 * Copyright (c) 2008-2016, GigaSpaces Technologies, Inc. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.mycompany.app;

import java.util.Properties;
import javax.sql.DataSource;

import org.hibernate.SessionFactory;
import org.openspaces.core.cluster.ClusterInfo;
import org.openspaces.core.cluster.ClusterInfoContext;
import org.openspaces.core.config.annotation.EmbeddedSpaceBeansConfig;
import org.openspaces.core.space.EmbeddedSpaceFactoryBean;
import org.openspaces.persistency.hibernate.DefaultHibernateSpaceDataSourceConfigurer;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.jdbc.datasource.DriverManagerDataSource;
import org.springframework.orm.hibernate5.LocalSessionFactoryBuilder;

public class CustomSpaceConfig extends EmbeddedSpaceBeansConfig {

    @ClusterInfoContext
    private ClusterInfo clusterInfo;

    @Value("${space.name}")
    private String spaceName;
    @Value("${db.driver}")
    private String dbDriver;
    @Value("${db.url}")
    private String dbUrl;
    @Value("${db.user:#{null}}")
    private String dbUser;
    @Value("${db.password:#{null}}")
    private String dbPassword;
    @Value("${hibernate.dialect}")
    private String hibernateDialect;
    @Value("${space.dataSource.limitResults:-1}")
    private int limitResults;
    @Value("${space.dataSource.fetchSize:100}")
    private int fetchSize;
    @Value("${space.mirror.redoLogCapacity:1_000_000}")
    private int mirrorRedoLogCapacity;
    @Value("${space.mirror.bulk-size:500}")
    private int mirrorBulkSize;
    @Value("${space.mirror.interval-millis:3000}")
    private long mirrorIntervalMillis;
    @Value("${space.mirror.interval-opers:500}")
    private long mirrorIntervalOpers;

    @Override
    protected void configure(EmbeddedSpaceFactoryBean factoryBean) {
        super.configure(factoryBean);

        factoryBean.setSpaceName(spaceName);
        factoryBean.setSchema("persistent");
        factoryBean.setMirrored(true);
        factoryBean.setSpaceDataSource(new DefaultHibernateSpaceDataSourceConfigurer()
            .sessionFactory(initSessionFactory())
            .clusterInfo(clusterInfo)
            .fetchSize(fetchSize)
            //.limitResults(limitResults)
            .create());

        Properties properties = new Properties();
        properties.setProperty("space-config.engine.cache_policy", "1"); // 1 == ALL IN CACHE
        properties.setProperty("space-config.external-data-source.usage", "read-only");
        properties.setProperty("cluster-config.cache-loader.external-data-source", "true");
        properties.setProperty("cluster-config.cache-loader.central-data-source", "true");
        properties.setProperty("space-config.engine.memory_usage.high_watermark_percentage",   "98");
        properties.setProperty("space-config.engine.memory_usage.write_only_block_percentage", "97");
        properties.setProperty("space-config.engine.memory_usage.write_only_check_percentage", "96");
        properties.setProperty("space-config.engine.memory_usage.low_watermark_percentage",    "95");
        properties.setProperty("space-config.engine.memory_usage.gc-before-shortage", "false");
        properties.setProperty("cluster-config.mirror-service.redo-log-capacity", String.valueOf(mirrorRedoLogCapacity)); 
        properties.setProperty("cluster-config.mirror-service.bulk-size", String.valueOf(mirrorBulkSize)); 
        properties.setProperty("cluster-config.mirror-service.interval-millis", String.valueOf(mirrorIntervalMillis)); 
        properties.setProperty("cluster-config.mirror-service.interval-opers", String.valueOf(mirrorIntervalOpers)); 
        factoryBean.setProperties(properties);
    }

    private SessionFactory initSessionFactory() {
        return new LocalSessionFactoryBuilder(initDataSource())
            .scanPackages("com.mycompany.app.model")
            .setProperty("hibernate.dialect", hibernateDialect)
            .setProperty("hibernate.cache.provider_class", "org.hibernate.cache.NoCacheProvider")
            .setProperty("hibernate.jdbc.use_scrollable_resultset", "false")
            .setProperty("hibernate.hbm2ddl.auto", "update")
            .buildSessionFactory();
    }

    private DataSource initDataSource() {
        DriverManagerDataSource dataSource = new DriverManagerDataSource();
        dataSource.setDriverClassName(dbDriver);
        dataSource.setUrl(dbUrl);
        dataSource.setUsername(dbUser);
        dataSource.setPassword(dbPassword);
        return dataSource;
    }
}
