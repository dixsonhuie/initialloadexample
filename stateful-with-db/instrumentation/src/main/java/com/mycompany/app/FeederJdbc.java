package com.mycompany.app;

import com.mycompany.app.model.Data;
import org.hibernate.query.criteria.internal.expression.function.AggregationFunction;
import org.openspaces.core.GigaSpace;
import org.openspaces.core.GigaSpaceConfigurer;
import org.openspaces.core.space.SpaceProxyConfigurer;

import java.sql.*;
import java.util.Date;
import java.util.Random;
import java.util.logging.Logger;

public class FeederJdbc {


    private final String dbUrl = "jdbc:sqlserver://172.31.4.60:1433;databaseName=piperdb;encrypt=false";
    private final String user = "piper";
    private final String pass = "Piper123*";
    private final String sqlInsert = "INSERT INTO Data (id, message, payload, processed) VALUES (?,?,?,?)";

    private static final int MAX_OBJECTS = 56_000_000 ;
    //private static final int MAX_OBJECTS = 1_000 ;
    private static final int MAX_PAYLOAD = 936;
    private static Logger log = Logger.getLogger(FeederJdbc.class.getName());

    private final int startId = 10702400;
    private final int batchSize = 100;
    private byte[] b;
    private int payloadSize = MAX_PAYLOAD;

    private void createPayload() {
        b = new byte[payloadSize];
        new Random().nextBytes(b);
    }

    private void modifyPayload() {
        int index = (int) (Math.random() * payloadSize);
        b[index] = (byte) new Random().nextInt(Byte.MAX_VALUE);
    }

    public void feeder() {
        createPayload();
        Random rd = new Random(new Date().getTime());

        try( Connection conn = DriverManager.getConnection(dbUrl, user, pass);
                PreparedStatement preparedStatement = conn.prepareStatement(sqlInsert);
                ) {

            conn.setAutoCommit(true);

            int i = startId;
            while (i < MAX_OBJECTS) {
                for(int j = i; j < (i + batchSize); j++) {
                    if (j >= MAX_OBJECTS) {
                        break;
                    }
                    modifyPayload();
                    preparedStatement.setInt(1, j);
                    preparedStatement.setString(2, String.format("msg  - %d", j));
                    preparedStatement.setBytes(3, b);
                    preparedStatement.setBoolean(4, false);
                    preparedStatement.addBatch();
                    if( j % 10000 == 0) {
                        log.info(String.format("Processing (%d) objects.", j));
                    }
                }

                int[] inserted = preparedStatement.executeBatch();
            //log.info("inserted.length is: " + inserted.length);
            i += batchSize;
        }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    public static void main(String[] args) {
        try {
            FeederJdbc feeder = new FeederJdbc();
            feeder.feeder();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
