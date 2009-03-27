package phi.db
{
	import mx.rpc.remoting.RemoteObject;
	
	
	/**
	 * A class for storing a connection information.<BR>
	 * 
	 * @see phi.db.Database
	 */
	public class ConnectionData
	{
		// Connection Constans
		public static const DESTINATION		:String = "amfphp";
		public static const SOURCE			:String = "mysql.database"
		
		// Connection Data
		public var remoteObj	:RemoteObject;
		
		protected var _name			:String;
		protected var _username		:String;
		protected var _password		:String;
		protected var _host 		:String;
		protected var _db			:String;
		
		
		/**
  		 * Constructor.
  		 * 
  		 * @param user the username of the remote application server
		 * @param pass the password of the remote application server
		 * @param host the server ip
		 * @param db the database name
  		 */
		public function ConnectionData(user:String="", pass:String="", host:String="", db:String="", name:String="default")
		{
			this.remoteObj = new RemoteObject(DESTINATION);
			this.remoteObj.source = SOURCE;
			
			this.name		= name;
			this.username 	= user;
			this.password 	= pass;
			this.host 		= host;
			this.db 		= db;			
		}
		
		public function clone():ConnectionData
		{
			return new ConnectionData(username, password, host, db);
		}
		
		public function get name():String {return _name;}
		public function get username():String {return _username;}
		public function get password():String {return _password;}
		public function get host():String {return _host;}
		public function get db():String {return _db;}
		
		public function set name(n:String):void {_name = n;}
		public function set username(u:String):void {_username = u;}
		public function set password(p:String):void {_password = p;}
		public function set host(h:String):void {_host = h;}
		public function set db(d:String):void {_db = d;}
		
		
	}
}