package com.example.Logger;

import java.io.File;
import java.util.concurrent.ConcurrentHashMap;
import java.util.logging.Level;
import java.util.logging.Logger;

public class Log {
	private static final ConcurrentHashMap<String, Logger> LOGGER = new ConcurrentHashMap<>();
	private static final ConcurrentHashMap<String, ConcurrentHashMap<String, Long>> PROCESS_INFO = new ConcurrentHashMap<>();
	
	private static final Level LOG_OFF = Level.FINE;
	private static final Level LOG_ON = Level.FINER;
	private static final Level LOG_PAYLOAD = Level.FINEST;

	private static final String LEVEL_OFF = "OFF";
	private static final String LEVEL_ON = "ON";
	private static final String LEVEL_PAYLOAD = "PAYLOAD";

	private static final int STATUS_OFF = 0;
	private static final int STATUS_ON = 1;
	private static final int STATUS_PAYLOAD = 2;
	
	public Log() {
		super();
	}
	
	public static void resetLogging() {
		LOGGER.clear();
	}
	
	public static void setLoglevel(String name, String level) {
		Logger logger = Logger.getLogger(name);
		logger.setLevel(getLevel(level));
		LOGGER.put(name, logger);
	}
	
	public static int isLoggingEnabled(String name){
		Level level = LOGGER.get(name).getLevel();
		if(level.equals(LOG_PAYLOAD))
			return STATUS_PAYLOAD;
		else if(level.equals(LOG_ON))
			return STATUS_ON;
		else
			return STATUS_OFF;
	}
	
	private static Level getLevel(String level) {
		if (LEVEL_PAYLOAD.equalsIgnoreCase(level))
			return LOG_PAYLOAD;
		else if (LEVEL_ON.equalsIgnoreCase(level))
			return LOG_ON;
		else if (LEVEL_OFF.equalsIgnoreCase(level))
			return LOG_OFF;
		else
			return LOG_OFF;
	}
	
	public static long CaptureEnd(String LoggerId, String context)
	{
		ConcurrentHashMap<String, Long> process = PROCESS_INFO.getOrDefault(LoggerId, new ConcurrentHashMap<String, Long>());
		Long startTime = process.get(context);
		
		return startTime == null ? -1 : System.currentTimeMillis() - startTime;
	}
	
	
	public static long CaptureStart(String LoggerId, String Context)
	{
		ConcurrentHashMap<String, Long> process = PROCESS_INFO.getOrDefault(LoggerId, new ConcurrentHashMap<String, Long>());
		Long startTime = System.currentTimeMillis();
		process.put(LoggerId, startTime);
		PROCESS_INFO.putIfAbsent(LoggerId, process);
		return startTime;
	}
	
	public static String ConstructMessageMetadata(
			String LogName, 
			String TransactionID, 
			String CorrelationID, 
            String OperationContext,  
            String ApplicationName, 
            int logSequence, 
            long elapsedTime, 
            long durationTime) {
        StringBuilder str = new StringBuilder(80);
        str.append(LogName);
        if (!"".equals(TransactionID)) {
            str.append("[[");
            str.append(TransactionID);
            str.append("]]");
        }
        if (!"".equals(CorrelationID)) {
            str.append("[#");
            str.append(CorrelationID);
            str.append("#]");
        }
        str.append("<<");
        if (logSequence < 10)
            str.append("0");
        str.append(logSequence);
        str.append(">>");
        if (!"".equals(ApplicationName)) {
            str.append("(@");
            str.append(ApplicationName);
            str.append("@)");
        }
        if (!"".equals(OperationContext)) {
            str.append("(#");
            str.append(OperationContext);
            str.append("#)");
        }
        if (elapsedTime >= 0) {
            str.append("{{+");
            str.append(elapsedTime);
            str.append("}}");
        }
        if (durationTime >= 0) {

            str.append("{{=");

            str.append(durationTime);

            str.append("}}");

        }

        return str.toString();

    }
	
	public long getFileLastModifiedTimestamp(String filename){
		File f = new File(filename);
		if(!f.exists()){
			return -1;
		}else{
			return f.lastModified();
		}
	}
}
