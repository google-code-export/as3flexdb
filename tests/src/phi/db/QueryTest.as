package phi.db
{
	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;

	import phi.interfaces.IQuery;
	import phi.interfaces.IDatabase;
	import mx.collections.ArrayCollection;
	import mx.utils.ArrayUtil;
	import flexunit.utils.ArrayList;	

	public class QueryTest extends TestCase
	{		
		/**
  		 * Constructor.
  		 * 
  		 * @param methodName the name of the test method an instance to run
  		 */
		public function QueryTest( methodName:String )
		{
			super( methodName );
		}  
        
        override public function setUp():void 
        {
        }
        
        override public function tearDown():void
        {
        }
        
		/**
		 * Create the TestSuite.
		 */
  		public static function suite():TestSuite
  		{
  			
   			var ts:TestSuite = new TestSuite();
   			
   			ts.addTest(new QueryTest("testInstance"));
   			ts.addTest(new QueryTest("testConnect"));
   			ts.addTest(new QueryTest("testExecute"));
   			ts.addTest(new QueryTest("testArrayInsert"));
   			ts.addTest(new QueryTest("testArrayUpdate"));
   			
   			
   			return ts;
   		}
   		
   		/**
  		 * Tests the Query instance
  		 */
  		public function testInstance():void
  		{  			
   			// Create a query object
   			var q:IQuery = new Query();
   			
   			// Test assertions
   			assertNotNull("new Query()!", q);
   			assertNotNull("Expecting records not null!", q.getRecords());
   			assertTrue("Expecting instance implements IQuery!", q is IQuery);
   			
   		}
   		
   		/**
   		 * Tests the connect
   		 */
   		 public function testConnect():void
   		 {
   		 	// Create a db and query object
   		 	var db :IDatabase = Database.getInstance();
   			var q  :IQuery = new Query();
   			
   			// Connect to database
   			db.connect("conn1", "root", "root", "localhost", "test", true);
   			q.connect(db.getDefaultConnectionName(), db);
   			   			
   			// Test assertions
   			assertNotNull("q.getConnection()", q.getConnection());
   			assertTrue("Expecting q.connection to be instance of ConnectionData", q.getConnection() is ConnectionData);
   			assertEquals("connection username", "root", q.getConnection().username);
   			
   		 }
   		 
   		 /**
   		 * Test execute
   		 */
   		 public function testExecute():void
   		 {
   		 	// Create a db and query object
   		 	var db 	:IDatabase 	= Database.getInstance();
   			var q  	:IQuery 	= new Query();
   			
   			// Time to execute the query in secounds
   			var sec :Number 	= 20;
   			
   			q.connect(db.getDefaultConnectionName(), db);   			
   			q.addEventListener(Query.QUERY_END, addAsync(verifyRecords, sec*1000));
   			q.addEventListener(Query.QUERY_ERROR, testFaild);
   			
   			q.execute("SELECT * FROM users WHERE 1");
   			
   		 }
   		 
   		 /**
   		 * Test Async connection with remote application server
   		 */
   		 private function verifyRecords(evt:Object):void
   		 {
   		 	// Test assertion
   		 	var q :IQuery = evt.target as IQuery;
   		 	
   		 	var records :ArrayCollection = q.getRecords();
   		 	var row		:Object = q.getRow();
   		 	
   		 	assertNotNull("Returned records instance", records);
   		 	assertNotNull("Returned row instance", row);
   		 	
   		 	//assertEquals("Number of rows", "2", records.length);
   		 	assertEquals("First returned row, username", "aaa", row.username);
   		 	assertEquals("First returned row, fname", "Pop", row.fname);
   		 	
   		 	// Get next row and test again
   		 	row = q.getRow();
   		 	
   		 	assertEquals("Secound returned row, username", "suru", row.username);
   		 	assertEquals("Secound returned row, fname", "Vlad", row.fname);
   		 	   		 		
   		 }
   		 
   		 /**
   		 * Test array insert
   		 */
   		 public function testArrayInsert():void
   		 {
   		 	// Create a db and query object
   		 	var db 	:IDatabase 	= Database.getInstance();
   			var q  	:IQuery 	= new Query();
 			
 			// Time to execute the query in secounds
   			var sec :Number 	= 20;
 			var arr :Array 		= new Array();
 			
 			arr.push({key: "username", value: "nou_user"});
 			arr.push({key: "fname", value: "User"});
 			
 			//db.connect("conn1", "root", "", "localhost", "test", true);
   			q.connect(db.getDefaultConnectionName(), db);
   			
   			q.addEventListener(Query.QUERY_END, addAsync(verifyInsert, sec*1000));
   			q.addEventListener(Query.QUERY_ERROR, testFaild);
			q.arrayInsert("users", arr);
   		 
   		 }
   		 
   		 /**
   		 * Test array update
   		 */
   		 public function testArrayUpdate():void
   		 {
   		 	// Create a db and query object
   		 	var db 	:IDatabase 	= Database.getInstance();
   			var q  	:IQuery 	= new Query();
   			
   			// Time to execute the query in secounds
   			var sec :Number 	= 20;
 			var arr :Array 		= new Array();
   			
   			arr.push({key: "username", value: "bogdan"});
 			arr.push({key: "fname", value: "Manate"});
   			
   			q.connect(db.getDefaultConnectionName(), db);
   			
   			q.addEventListener(Query.QUERY_END, addAsync(verifyUpdate, sec*1000));
   			q.addEventListener(Query.QUERY_ERROR, testFaild);
   			q.arrayUpdate("users", arr, "id = 4");
   		 }
   		 
   		 /**
   		 * Test Async connection with remote application server
   		 */
   		 private function verifyInsert(evt:Object):void
   		 {
   		 	// Test assertion
   		 	var q :IQuery = evt.target as IQuery;
   		 	assertTrue("Last insert id not 0", q.getLastInsertID() != 0);
   		 }
   		 
   		 /**
   		 * Test Async connection with remote application server
   		 */
   		 private function verifyUpdate(evt:Object):void
   		 {
   		 	// Test assertion
   		 	var q :IQuery = evt.target as IQuery;
   		 	
   		 	assertTrue("ArrayInsert faild!", q.getLastInsertID() == 0);

   		 }
   		 
   		 /**
   		 * Generic faild function if there are SQL errors
   		 */
   		 private function testFaild(evt:Object):void
   		 {
   		 	var q :IQuery = evt.target as IQuery;
   		 	throw Error(q.getError());
   		 }
   		 
	}
}