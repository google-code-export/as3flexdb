package phi.interfaces
{
	import phi.interfaces.IQuery;
	import phi.db.ConnectionData;
	
	/**
	 * The interface definition for a <code>Database</code> object.
	 * 
	 * <P>
	 * A <code>IDatabase</code> implementor have these responsibilities:
	 * <UL>
	 * <LI>Create a connection with a remote application server.</LI>
	 * <LI>Provide a method for <code>IQuery</code> to access classes on a remote application server and execute a SQL statements.</LI>
	 * </UL>
	 *
	 * @see phi.interfaces.IQuery
	 */
	public interface IDatabase
	{
		/**
		 * Create a new connection with a remote application server. This 
		 * connection can be use for execute SQL statements to a database.<br>
		 * More then one connection can be made but you must enter at least
		 * one connection for the <code>Database</code> object to work.
		 * 
		 * @example The following code create 2 connections:
		 * <listing version="3.0">
		 * var db:IDatabase = Database.getInstance();
		 * 
		 * db.connect("conn1", "pop", "poppass", "localhost", "yb20");
		 * db.connect("conn2", "pop", "poppass", "localhost", "test_db");
		 * 
		 * </listing>
		 * 
		 * @param name the name of the connection
		 * @param user the username of the remote application server
		 * @param pass the password of the remote application server
		 * @param host the server ip
		 * @param db the database name
		 * @param bDefault set this connection as a default connection
		 * 
		 * @throws Error Error if a connection with the same name allready exist.
		 */
		function connect(name:String, user:String, pass:String, host:String, db:String, bDefault:Boolean = false):void;
		
		/**
		 * Disconnect from a previous connection
		 * 
		 * @param name the name of the connection
		 * @throws Error Error if the connection don't exist.
		 */
		function disconnect(name:String):void;
		
		/**
		 * Retrieve an connection information.
		 * 
		 * @param connectionName the name of the connection to retrieve.
		 * @return an <code>ConnectionData</code> instance previously created with the <code>connect</code> function.
		 * 
		 * @throws Error Error if the connection don't exist.
		 */
		function retrieveConnection(connectionName:String):ConnectionData;
		
		/**
		 * Get the number of current open connections.
		 * 
		 * @return the number of current open connections.
		 */
		function getConnections():Number;
		
		/**
		 * Get the default connection name
		 * 
		 * @return a string with the name of the default connection
		 */
		 function getDefaultConnectionName():String;
		 
		 /**
		 * Set a connection as a default
		 * 
		 * @param name the connection name
		 * @return
		 */
		 function setDefaultConnection(name:String):void;
	}
}