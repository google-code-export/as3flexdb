package phi.db
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import phi.controls.phiBusy;
	import phi.interfaces.IDatabase;
	import phi.interfaces.IQuery;
	
	/**
	 *  Dispatched befor starting execute a SQL statement.
	 * 
	 * <P>The endQuery event is dispatched when the <code>execute()</code>
	 * or <code>arrayInsert()</code> method is called.<BR>
	 * 
	 *  @eventType phi.db.Query.QUERY_START
	 */
	[Event(name="startQuery", type="flash.events.Event")]
	
	/**
	 *  Dispatched after the SQL statement was executed.
	 * 
	 * <P>The endQuery event is dispatched when the <code>execute()</code>
	 * or <code>arrayInsert()</code> method is called.<BR>
	 * At the time when this event is sent, the <code>Query</code> object has been
	 * retrieve the records if a SELECT statements was execute or the last inserted id
	 * if a INSERT statement was execute.</P>
 	 * 
	 * @eventType phi.db.Query.QUERY_END
	 */
	[Event(name="endQuery", type="flash.events.Event")]

	/**
	 *  Dispatched when the SQL statement contains errors.
	 * 
	 * <P>At the time when this event is sent, the <code>Query</code> 
	 * object has been save the error message.<BR>To retrieve the error message
	 * you should use <code>getError()<code> method.
	 * 
	 * @eventType phi.db.Query.QUERY_END
	 */
	[Event(name="errorQuery", type="flash.events.Event")]
	
	/**
	 * A <code>IQuery</code> implementation.
	 * 
	 * <P>
	 * A <code>Query</code> object assumes these responsibilities:
	 * <UL>
	 * <LI>Execute a SQL statement on a database.</LI>
	 * <LI>Retrive the result returned by database engine.</LI>
	 * <LI>Dispatch error event if any error appear.</LI>
	 * </UL>
	 * 
	 * @see phi.db.Database
	 */
	public class Query extends EventDispatcher implements IQuery
	{
		/** 
		 * The Query.QUERY_START constant defines the value of the type property 
		 * of the event object for an event that is dispatched before a SQL statement
		 * start execute.
		 */
		public static const QUERY_START		:String = "startQuery";
		
		/**
		 * The Query.QUERY_END constant defines the value of the type property 
		 * of the event object for an event that is dispatched after a SQL statement
		 * has finish the execution.
		 */
		public static const QUERY_END		:String = "endQuery";
		
		/**
		 * The Query.QUERY_ERROR constant defines the value of the type property 
		 * of the event object for an event that is dispatched when a SQL error appear
		 * on a <code>execute()</code> method.
		 */
		public static const QUERY_ERROR		:String = "errorQuery";
		
		// Operation Constants
		public static const SELECT	:String = "select";
		public static const INSERT :String = "insert";
		public static const UPDATE :String = "update";
		public static const DELETE	:String = "delete";
		
		// Last query
		private var query :String;
		
		// Connection object
		private var conn :ConnectionData;
		
		// Database object
		private var db :IDatabase;
		
		// Result of the last query
		private var records :ArrayCollection;
		
		// Step of the next getRow()
		private var step :Number;
		
		// Last query error
		private var error :String;
		
		// Current operation
		private var op :String;
		
		// The ID generated for an AUTO_INCREMENT
		private var nLastID :Number;
		
		private var queryStack	:Array;
		private var bExecute	:Boolean;
		
		/**
		 * Constructor
		 */
		public function Query()
		{
			this.records = new ArrayCollection();
			this.step	 = 0;
			this.nLastID = 0;
			this.error   = "";
			
			this.op		 = Query.SELECT;
			queryStack	 = new Array();
			bExecute	 = false;
		}
		
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
		public function connect(connection:String, db:IDatabase):void
		{
			conn = db.retrieveConnection(connection);
		}
		
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
		public function execute(q:String, option:String = Query.SELECT):void
		{
			if(bExecute == true)
			{
				var obj :Object = new Object();
				
				obj.q 		= q;
				obj.option	= option;
				
				queryStack.push(obj);
				return;
			}
			
			this.query 		= q;
			this.op    		= option;
			this.step  		= 0;
			this.bExecute	= true;
						
			startConnection();
			conn.remoteObj.getOperation("query").send(q, conn.username, conn.password, conn.host, conn.db);
		}
		
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
		 public function arrayInsert(table:String, arr:Array):String
		 {
		 	var q		:String = "";
		 	var keys 	:Array 	= new Array();
		 	var values	:Array 	= new Array();
		 	
		 	for(var i:Number = 0; i<arr.length; i++)
		 	{
		 		keys.push(arr[i].key);
		 		values.push(arr[i].value);
		 	}
		 	
		 	q = 'INSERT INTO '+table+' (`'+keys.join('`,`')+'`) VALUES ("'+values.join('","')+'")';		 	
		 	execute(q, Query.INSERT);
		 	
		 	return q;
		 }
		 
		 /**
		 * Execute a UPDATE query on a table.
		 * 
		 * <P>This function can be used to update data into database. After parsing
		 * the array this function generate a SQL statement and execute it with
		 * <code>execute()</code> method.
		 * 
		 * @example Next example update the fname,lname of the user with id = 4:
		 * <listing>
		 * private functin updateUser(q:IQuery):void
		 * {
		 * 		var arr :Array = new Array();
		 * 
		 * 		arr.push({key: fname, value: "New_FName"});
		 * 		arr.push({key: lname, value: "New_LName"});
		 * 
		 * 		q.addEventListener(Query.QUERY_END, processQuery);
		 * 		q.addEventListener(Query.QUERY_ERROR, processQueryError);
		 * 		q.arrayUpdate("users", arr, "id = 4");
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
		 * @param cond the condition after the update will be made
		 * 
		 * @return the SQL generated from array.
		 */
		 public function arrayUpdate(table:String, arr:Array, cond:String):String
		 {
		 	var q		:String = "";
		 	var body	:String = "";
		 	
		 	for(var i:Number = 0; i<arr.length - 1; i++)
		 		body += "`"+arr[i].key+'` = "'+arr[i].value+'", ';
		 	
			body += "`"+arr[i].key+'` = "'+arr[i].value+'" ';
		
			q = "UPDATE "+table+" SET "+body+" WHERE "+cond;
			execute(q, Query.UPDATE);
			
		 	return q;
		 }
		 
		/**
		 * Get the records selected with a previous <code>execute()</code> method.
		 * 
		 * @return a <code>ArrayCollection</code> with all selected records.
		 */
		 [Bindable (event="endQuery")]	 
		 public function getRecords():ArrayCollection
		 {
		 	return records;
		 }
		 
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
		 public function getRow():Object
		 {
		 	if(records == null)
		 		return null;
		 		
		 	if(records.length-1 < step)
		 		return null;
		 		
		 	var row :Object = records[step];
		 	step++;
		 			 		
		 	return row;
		 }
		 
 		 /**
		 * Get the current used connection.
		 * 
		 * @return the current used connection for execution of SQL statement.
		 */
		 public function getConnection():ConnectionData
		 {
		 	return conn;
		 }
		 
		 /**
		 * Get the ID generated for an AUTO_INCREMENT column by the previous INSERT query.
		 * 
		 * @return the ID generated for an AUTO_INCREMENT
		 */
		 public function getLastInsertID():Number
		 {
		 	return nLastID;
		 }
		 
		 /**
		 * 
		 * @return true if execute stack is empty.
		 */
		 public function isStackEmpty():Boolean
		 {
		 	return (this.queryStack.length == 0)
		 }
		 
		 /**
		 * Return the query.
		 * 
		 * @return the query.
		 */
		 override public function toString():String
		 {
		 	return query;
		 }
		 
		 /**
		 * Get the last SQL error.
		 * 
		 * @return the SQL error.
		 */
		 public function getError():String
		 {
		 	return error;
		 }
		 
		 /**
		 * 
		 */
		 private function executeNextStackQuery():void
		 {
		 	this.bExecute = false;
		 	if(this.queryStack.length > 0)
		 	{
		 		var obj :Object = this.queryStack.shift();
		 		this.execute(obj.q, obj.option);
		 	}
		 }
		 
		 /**
		 * 
		 */
		 private function onQueryEnd(evt:ResultEvent):void
		 {
		 	// Check for SQL errors.
		 	if(evt.result is String)
		 	{
		 		records = null;
		 		error	= evt.result as String;
		 		dispatchEvent(new Event(Query.QUERY_ERROR));
		 		
		 		endConnection();
		 		return;
		 	}
		 	
		 	switch(this.op)
		 	{
		 		case Query.SELECT:
		 		{
		 			records = evt.result as ArrayCollection;
		 			dispatchEvent(new Event(Query.QUERY_END));
		 		}
		 		break;
		 		
		 		case Query.DELETE:
		 		case Query.INSERT:
		 		case Query.UPDATE:
		 		{
		 			nLastID = evt.result as Number;
		 			dispatchEvent(new Event(Query.QUERY_END));
		 		}
		 		break;
		 	}
		 	
		 	endConnection();
		 	executeNextStackQuery();
		 		 	
		 }
		 
		 /**
		 * 
		 */
		 private function onQueryFault(evt:FaultEvent):void
		 {
		 	throw(evt.toString());
		 }
		 
		 private function startConnection():void
		 {
		 	conn.remoteObj.getOperation("query").addEventListener(FaultEvent.FAULT, onQueryFault);
			conn.remoteObj.getOperation("query").addEventListener(ResultEvent.RESULT, onQueryEnd);
			
			dispatchEvent(new Event(Query.QUERY_START));
			phiBusy.showBusy();
		 }
		 
		 private function endConnection():void
		 {
		 	conn.remoteObj.removeEventListener(FaultEvent.FAULT, onQueryFault);
		 	conn.remoteObj.removeEventListener(ResultEvent.RESULT, onQueryEnd);
		 	
		 	//CursorManager.removeBusyCursor();
		 	phiBusy.removeBusy();
		 }
	}
}