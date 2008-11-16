package phi.db
{
	import phi.interfaces.IDatabase;
	import phi.interfaces.IQuery;
	
	import phi.db.ConnectionData;
	
	import mx.rpc.remoting.RemoteObject;

	/**
	 * A Singleton <code>IDatabase</code> implementation.
	 * 
	 * <P>
	 * A <code>Database</code> object assumes these responsibilities:
	 * <UL>
	 * <LI>Create a connection with a remote application server.</LI>
	 * <LI>Provide a method for <code>IQuery</code> to access classes on a remote application server and execute a SQL statements.</LI>
	 * </UL>
	 * 
	 * @see phi.db.Query
	 */
	public class Database implements IDatabase
	{
		// Error message Constants
		private static const SINGLETON_ERR :String = "Database already constructed!";
		private static const CONNECTION_EXIST_ERR :String = "A connection with the same name exist!";
		private static const CONNECTION_NOT_EXIST_ERR :String = "A connection with this name don't exist!";
				
		// Singleton instance
		private static var instance :IDatabase;
		
		// Mapping of Connection names
		private var connectionMap :Array;
		
		// The number of the current open connections
		private var nConnect :Number;
		
		// The name of the default connection
		private var sDefaultConnection :String;
		
		/**
		 * Constructor. 
		 * 
		 * <P>
		 * This <code>IDatabase</code> implementation is a Singleton, 
		 * so you should not call the constructor 
		 * directly, but instead call the static Singleton 
		 * Factory method <code>Database.getInstance()</code>
		 * 
		 * @throws Error Error if Singleton instance has already been constructed
		 * 
		 */
		public function Database()
		{
			if (instance != null) throw Error(SINGLETON_ERR);
			
			instance = this;
			
			nConnect = 0;
			connectionMap = new Array();
		}
		
		/**
		 * <code>Database</code> Singleton Factory method.
		 * 
		 * @return the Singleton instance of <code>Database</code>
		 */
		public static function getInstance():IDatabase
		{
			if ( instance == null ) instance = new Database()
			return instance;
		}
		
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
		public function connect(name:String, user:String, pass:String, host:String, db:String, bDefault:Boolean = false):void
		{
			if(this.connectionMap[name] == null)
			{
				this.connectionMap[name] = new ConnectionData(user, pass, host, db);
				
				if(bDefault) 
					this.sDefaultConnection  = name;
				
				this.nConnect++;
			} else
			throw Error(CONNECTION_EXIST_ERR);

		}
		
		/**
		 * Disconnect from a previous connection
		 * 
		 * @param name the name of the connection
		 * @throws Error Error if the connection don't exist.
		 */
		public function disconnect(name:String):void
		{
			if(this.connectionMap[name] != null)
			{
				this.connectionMap[name] = null;
				this.nConnect--;
			} else
			throw Error(CONNECTION_NOT_EXIST_ERR);
			
		}
		
		/**
		 * Get the default connection name
		 * 
		 * @return a string with the name of the default connection
		 */
		 public function getDefaultConnectionName():String
		 {
		 	return this.sDefaultConnection;
		 }
		 
		 /**
		 * Set a connection as a default
		 * 
		 * @param name the connection name
		 * @return
		 */
		 public function setDefaultConnection(name:String):void
		 {
		 	this.sDefaultConnection = name;
		 }
		
		/**
		 * Retrieve an connection information.
		 * 
		 * @param connectionName the name of the connection to retrieve.
		 * @return an <code>ConnectionData</code> instance previously created with the <code>connect</code> function.
		 * 
		 * @throws Error Error if the connection don't exist.
		 */
		public function retrieveConnection(connectionName:String):ConnectionData
		{
			if(this.connectionMap[connectionName] == null)
				throw Error(CONNECTION_NOT_EXIST_ERR);
			
			return (connectionMap[connectionName] as ConnectionData).clone();
		}
		
		/**
		 * Get the number of current open connections.
		 * 
		 * @return the number of current open connections.
		 */
		public function getConnections():Number
		{
			return nConnect;
		}

	}
}