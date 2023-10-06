package com.mycompany.app;

import com.mycompany.app.model.Data;
import org.openspaces.core.GigaSpace;
import org.openspaces.core.GigaSpaceConfigurer;
import org.openspaces.core.space.SpaceProxyConfigurer;

import java.util.Date;
import java.util.Random;
import java.util.logging.Logger;

public class InstrumentationExample {

    private static final int MAX_PAYLOAD = 920;





    public void getObjectSize() {
        Random rd = new Random(new Date().getTime());

        Data data = new Data();
        Integer id = new Integer(1);
        String message = "Message: " + id;


        byte[] arr = new byte[MAX_PAYLOAD];
        rd.nextBytes(arr);

        data.setId(id);
        data.setMessage(message);
        data.setPayload(arr);
        data.setProcessed(Boolean.FALSE);

	System.out.println("Example 1:");
        printObjectSize(data);
        printObjectSize(id);
        printObjectSize(message);
        printObjectSize(arr);
        printObjectSize(Boolean.FALSE);

        data = new Data();
        id = new Integer(17_000_000);
        message = "Message: " + id;

        rd.nextBytes(arr);

        data.setId(id);
        data.setMessage(message);
        data.setPayload(arr);
        data.setProcessed(Boolean.FALSE);

	System.out.println("Example 2:");
        printObjectSize(data);
        printObjectSize(id);
        printObjectSize(message);
        printObjectSize(arr);
        printObjectSize(Boolean.FALSE);
    }

    public static void printObjectSize(Object object) {
        System.out.println(String.format("Object type: %40s, size: %d bytes", 
                object.getClass(),
                InstrumentationAgent.getObjectSize(object)));
    }

    public static void main(String[] args) {
        try {

            InstrumentationExample example = new InstrumentationExample();
            example.getObjectSize();

        } catch (Exception e) {
            e.printStackTrace();
        }
        System.exit(0);
    }
}
