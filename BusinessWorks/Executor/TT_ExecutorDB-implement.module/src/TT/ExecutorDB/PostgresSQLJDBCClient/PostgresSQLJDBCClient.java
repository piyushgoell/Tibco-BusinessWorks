package TT.ExecutorDB.PostgresSQLJDBCClient;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public class PostgresSQLJDBCClient implements Runnable {
	String host = "localhost";
    int port = 5432;
    String database = "mydb";
    String username = "myuser";
    String password = "mypassword";
	String jdbcURL = null;
	double connection_timeout = 20;
	
	
	
	public PostgresSQLJDBCClient(String host, int port, String database,
			 String username, String password) throws SQLException {
		super();
		this.host = host;
		this.port = port;
		this.database = database;
		this.username = username;
		this.password = password;
		init();
	}

	public void init() throws SQLException
    {
        Properties props = getProperties();
        try (Connection jdbcConnection = initializeJDBC(props))
        {
            System.out.println("\nConnected to data grid: " + jdbcURL);
        }
        catch (SQLException sqlex)
        {
        	
        }
    }
	
	public Connection initializeJDBC (Properties props) throws SQLException
    {

        if (jdbcURL == null)
        {
            jdbcURL = "jdbc:postgresql://" + host + ":" + port + "/" + database;
        }
        Connection jdbcConnection = DriverManager.getConnection(jdbcURL, props);
        return jdbcConnection;
        
        
    }
	
	public Properties getProperties()
    {
        // sets the datagrid.Connection and datagrid.Session properties
        // parsed command line options override default property settings
        Properties props = new Properties();
        
        props.setProperty(org.postgresql.PGProperty.CONNECT_TIMEOUT.toString(), String.valueOf(connection_timeout));
        if (username != null && password != null)
        {
            props.setProperty(org.postgresql.PGProperty.USER.toString(), username);
            props.setProperty(org.postgresql.PGProperty.PASSWORD.toString(), password);
        }

        return props;
    }

	@Override
	public void run() {
		// TODO Auto-generated method stub
		
	}
}
