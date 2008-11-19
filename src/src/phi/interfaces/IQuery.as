package phi.interfaces
{
	import flash.events.IEventDispatcher;
	
	import mx.collections.ArrayCollection;
	
	import phi.db.ConnectionData;
	
	/**
	 * The interface definition for a <code>Query</code> object.
	 * 
	 * <P>
	 * A <code>IQuery</code> implementor have these responsibilities:
	 * <UL>
	 * <LI>Execute a SQL statement on a database.</LI>
	 * <LI>Retrive the result returned by database engine.</LI>
	 * <LI>Dispatch error event if any error appear.</LI>
	 * </UL>
	 * 
	 * @see phi.db.IDatabase
	 */
	public interface IQuery extends IEventDispatcher
	{
		/**
		 * This function allow to select the connection you want to
		 * use for executing a SQL statements. <BR>You must create a connection
		 * with <code>Database.connect()</code> before using this.
		 * <P>
		 * You must select a connection before doing any operations
		 * with a <code>Query</code> object.
		 * 
		 * @example The next exemple select the second connection:
		 * <listing>
		 * var db :IDatabase = Database.getInstance();
		 * var q  :IQuery	 = new Query();
		 * 
		 * db.connect("conn1", "pop", "poppass", "localhost", "yb20");
		 * db.connect("conn2", "pop", "poppass", "localhost", "test_db");
		 * 
		 * q.connect("conn2");
		 * </listing>
		 * 
		 * @param connection the connection name
		 * @param db a IDatabase object
		 * 
		 * @see phi.db.Database
		 */
		function connect(connection:String, db:IDatabase):void;
		function set database(db:IDatabase):void
		
		/**
		 * Execte a SQL statement.
		 * 
		 * Before executing the SQL statement this function dispatch a Query.QUERY_START
		 * event and when the SQL statement has finish execution a Query.QUERY_END will be
		 * dispatched.
		 * 
		 * @example Next example will select all users from a users table:
		 * <listing>
		 * var db :IDatabase = Database.getInstance();
		 * var q  :IQuery	 = new Query();
		 * 
		 * private function connect():void
		 * {
		 * 		db.connect("conn1", "pop", "poppass", "localhost", "test_db");
		 * 		q.connect("conn1");
		 * }
		 * 
		 * private function getUsers():void
		 * {
		 * 		connect();
		 * 
		 * 		q.addEventListener(Query.QUERY_END, onGetUsers);
		 * 		q.execute("SELECT fname FROM users WHERE 1");
		 * }
		 * 
		 * private function onGetUsers(evt:Object):void
		 * {
		 * 		var q		:IQuery			 = evt.target as IQuery;
		 * 		var users	:ArrayCollection = q.getRecords();
		 * }
		 * </listing>
		 * 
		 * @param q the SQL string
		 * @param option leave this on default
		 * 
		 * @throws Error Error if there are any SQL errors.
		 */
		function execute(q:String, option:String = "select"):void;
		function set q(s:String):void;
		
		/**
		 * Execute a INSERT query on a table.
		 * 
		 * <P>This function can be used to save data into database. After parsing
		 * the array this function generate a SQL statement and execute it with
		 * <code>execute()</code> method.
		 * 
		 * @example Next example insert a new user in database:
		 * <listing>
		 * private functin insertNewUsers(q:IQuery):void
		 * {
		 * 		var arr :Array = new Array();
		 * 
		 * 		arr.push({key: fname, value: "pop"});
		 * 		arr.push({key: lname, value: "lpopname"});
		 * 
		 * 		q.addEventListener(Query.QUERY_END, processQuery);
		 * 		q.addEventListener(Query.QUERY_ERROR, processQueryError);
		 * 		q.arrayInsert("users", arr);
		 * }
		 * 
		 * private function processQuery(evt:Object):void
		 * {
		 * 		....
		 * }
		 * 
		 * private function processQueryError(evt:Object):void
		 * {
		 *  	...
		 * }
		 * </listing>
		 * 
		 * @param table the name of the table
		 * @param arr the array that contains the data.
		 * 
		 * @return the SQL generated from array.
		 */
		 function arrayInsert(table:String, arr:Array):String;
		 
		 /**
		 * Execute a UPDATE query on a table.
		 * 
		 */
		 function arrayUpdate(table:String, arr:Array, cond:String):String;
		 
		/**
		 * Get the records selected with a previous <code>execute()</code> method.
		 * 
		 * @return a <code>ArrayCollection</code> with all selected records.
		 */
		 [Bindable (event="endQuery")]
		 function getRecords():ArrayCollection;
		 
		 /**
		 * Get the next row from a previous selected records.
		 * 
		 * <P>This function can be used to process the selected records.
		 * @example Next example will select all users from a db and add "_process" string to the end on fname
		 * <listing>
		 * ......
		 * ......
		 * 
		 * private functin process(q:IQuery):void
		 * {
		 * 		var row :Object = new Object();
		 * 		while((row = q.getRow()) != null)
		 * 		{
		 * 			row.fname += "_process";
		 * 		}
		 * }
		 * </listing>
		 * 
		 * @return a <code>Object</code> with the row information.
		 */
		 function getRow():Object;
		 
		 /**
		 * Get the current used connection.
		 * 
		 * @return the current used connection for execution of SQL statement.
		 */
		 function getConnection():ConnectionData;

		/**
		 * Get the ID generated for an AUTO_INCREMENT column by the previous INSERT query.
		 * 
		 * @return the ID generated for an AUTO_INCREMENT
		 */
		 function getLastInsertID():Number;
		 
		 /**
		 * Return the query.
		 * 
		 * @return the query.
		 */
		 function toString():String;
		 
		 /**
		 * Get the last SQL error.
		 * 
		 * @return the SQL error.
		 */
		 function getError():String;
		 
		 /**
		 * 
		 * @return true if execute stack is empty.
		 */
		 function isStackEmpty():Boolean;
		 
		 function set queryEnd(f:Function):void
		
	}
}