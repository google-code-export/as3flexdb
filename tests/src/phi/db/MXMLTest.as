package phi.db
{
	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;
	
	import mx.collections.ArrayCollection;
	
	import phi.interfaces.IDatabase;
	import phi.interfaces.IQuery;
 	
	public class MXMLTest extends TestCase
	{
		private var _db :IDatabase = null;
		private var _q	:IQuery = null;
		
		/**
  		 * Constructor.
  		 * 
  		 * @param methodName the name of the test method an instance to run
  		 */
		public function MXMLTest( methodName:String, db:IDatabase, q:IQuery )
		{
			super( methodName );
			_db = db;
			_q = q;
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
  		public static function suite(db:IDatabase, q:IQuery):TestSuite
  		{
  			var ts:TestSuite = new TestSuite();
   			
   			ts.addTest(new MXMLTest("testInstance", db, q));
   			ts.addTest(new MXMLTest("testConnectionDataSet", db, q));
			
   			return ts;
   		}
   		
   		/**
  		 * Tests the View Singleton Factory Method 
  		 */
  		public function testInstance():void
  		{  			
   			// Test assertions
   			assertNotNull("MXML Database object not null", _db);
   			assertNotNull("MXML Query object not null", _q);
   		}
   		
   		/**
   		 * Tests if ConnectionData has been intialized with success.
   		 */
   		public function testConnectionDataSet():void
   		{
   			var c:ConnectionData = _db.retrieveConnection(_db.getDefaultConnectionName());
   			
   			assertNotNull("Connection data not null", c);
   			assertEquals("Connection username", "root", c.username);
   			assertEquals("Connection password", "root", c.password);
   			assertEquals("Connection host", "localhost", c.host);
   		}
   		
   		/**
   		 * Test execute
   		 */
   		 public function testExecute():void
   		 {
   		 	// Time to execute the query in secounds
   			var sec :Number 	= 20;
   			/*
   			_q.connect(db.getDefaultConnectionName(), db);   			
   			_q.addEventListener(Query.QUERY_END, addAsync(verifyRecords, sec*1000));
   			_q.addEventListener(Query.QUERY_ERROR, testFaild);
   			
   			q.execute("SELECT * FROM users WHERE 1");
   			*/
   			
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
   		 	assertEquals("First returned row, username", "puser", row.username);
   		 	assertEquals("First returned row, fname", "Pop", row.fname);
   		 	
   		 	// Get next row and test again
   		 	row = q.getRow();
   		 	
   		 	assertEquals("Secound returned row, username", "suru", row.username);
   		 	assertEquals("Secound returned row, fname", "Vlad", row.fname);
   		 	   		 		
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