package com.mycompany.app;

import com.mycompany.app.model.Data;
import org.openspaces.core.GigaSpace;
import org.openspaces.core.GigaSpaceConfigurer;
import org.openspaces.core.space.SpaceProxyConfigurer;

import java.util.Date;
import java.util.Random;
import java.util.logging.Logger;

public class Feeder {

    // each object will have a 1k payload
    // this will be roughly 10 gb of data
    private static final int DEFAULT_MAX_OBJECTS = 10 * 1024 * 1024;

    private int maxObjects = DEFAULT_MAX_OBJECTS;

    private static final int MAX_PAYLOAD = 936;

    private static Logger logger = Logger.getLogger(Feeder.class.getName());

    public static final String GS_LOOKUP_GROUPS = "GS_LOOKUP_GROUPS";
    public static final String GS_LOOKUP_LOCATORS = "GS_LOOKUP_LOCATORS";

    private static final String spaceName = "demo";

    private GigaSpace gigaSpace;

    static {
        // for debug purposes
        // 1. set from environment variable, XAP checks this for lookup settings
        System.out.println("lookup locators env variable: " + System.getenv(GS_LOOKUP_LOCATORS));
        System.out.println("lookup groups   env variable: " + System.getenv(GS_LOOKUP_GROUPS));
        // 2. set from System.property, XAP also checks this for lookup settings
        System.out.println("lookup locators System property: " + System.getProperty("com.gs.jini_lus.locators"));
        System.out.println("lookup groups   System property: " + System.getProperty("com.gs.jini_lus.groups"));
    }

    public void processArgs(String[] args) {

        try {
            int i = 0;
            while (i < args.length) {
                String s = args[i];
                String sUpper = s.toUpperCase();

                if (sUpper.startsWith("--help".toUpperCase())) {
                    printUsage();
                    System.exit(0);
                }
                else if (sUpper.startsWith("--max_objects".toUpperCase())) {
                    String[] sArray = s.split("=", 2);
                    String value = sArray[1];
                    maxObjects = Integer.parseInt(value);
                }
                else {
                    System.out.println("Please enter valid arguments.");
                    printUsage();
                    System.exit(0);
                }
                i++;
            }
        } catch (Exception e) {
            e.printStackTrace();
            printUsage();
            System.exit(-1);
        }
    }
    public void displayArgs() {
        System.out.println("maxObjects is set to: " + maxObjects);
    }

    public static void printUsage() {
        System.out.println("This program creates objects for testing purposes.");
        System.out.println("The following arguments are used:");
        System.out.println("  --max_objects=<n>");
        System.out.println("    The number of objects to write to the space>. Default is: " + DEFAULT_MAX_OBJECTS);
        System.out.println("  --help");
        System.out.println("    Display this help message.");
    }
    private void initialize() {
        SpaceProxyConfigurer spaceProxyConfigurer = new SpaceProxyConfigurer(spaceName);
        gigaSpace = new GigaSpaceConfigurer(spaceProxyConfigurer).gigaSpace();
    }

    public void feeder() {
        Random rd = new Random(new Date().getTime());

        for (int i = 0; i < maxObjects; i++) {
            Data data = new Data();
            data.setId(i);
            data.setMessage("Message: " + i);
            byte[] arr = new byte[MAX_PAYLOAD];
            rd.nextBytes(arr);
            data.setPayload(arr);
            data.setProcessed(Boolean.FALSE);
            gigaSpace.write(data);
        }
    }


    public static void main(String[] args) {
        try {

            Feeder feeder = new Feeder();
            feeder.processArgs(args);
            feeder.displayArgs();
            feeder.initialize();
            feeder.feeder();

        } catch (Exception e) {
            e.printStackTrace();
        }
        System.exit(0);
    }
}
