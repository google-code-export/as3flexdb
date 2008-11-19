package phi.db
{
	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;
	
	import phi.interfaces.IDatabase;

	public class DatabaseTest extends TestCase
	{
		
		/**
  		 * Constructor.
  		 * 
  		 * @param methodName the name of the test method an instance to run
  		 */
		public function DatabaseTest( methodName:String )
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
   			
   			ts.addTest(new DatabaseTest("testGetInstance"));
   			ts.addTest(new DatabaseTest("testConnect"));
   			ts.addTest(new DatabaseTest("testDisconnect"));
   			
   			return ts;
   		}
   		
   		/**
  		 * Tests the View Singleton Factory Method 
  		 */
  		public function testGetInstance():void
  		{  			
   			// Test Factory Method
   			var db:IDatabase = Database.getInstance();
   			
   			// Test assertions
   			assertNotNull("Database.getInstance()", db);
   		}
   		
   		public function testConnect():void
   		{
   			// Get the Singleton Database instance
  			var db:IDatabase = Database.getInstance();
  			
  			// Create a connection
  			db.connect("conn1", "root", "1234", "localhost", "test");
  			db.connect("conn2", "pop", "159", "localhost", "yb");
  			
  			var connection 	:ConnectionData = db.retrieveConnection("conn1");
  			var nrConn		:Number = db.getConnections();
  			
  			// Test assertions
  			assertTrue("Expecting db.retrieveConnection('conn1') is ConnectionData", db.retrieveConnection("conn1") is ConnectionData);
  			assertTrue("Expecting  instance not null", connection != null);
  			assertEquals("connection.username", "root", connection.username);
  			assertEquals("connection.password", "1234", connection.password);
  			assertEquals("connection.host", "localhost", connection.host);
  			assertEquals("connection.db", "test", connection.db);
  			//assertEquals("getConnection()", 2, db.getConnections());
  			
  			connection = db.retrieveConnection("conn2");
  			
  			assertEquals("connection.username", "pop", connection.username);
  			assertEquals("connection.password", "159", connection.password);
   		}
   		
   		public function testDisconnect():void
   		{
   			// Get the Singleton Database instance
  			var db :IDatabase = Database.getInstance();
  			var c  :Number = db.getConnections();
  			
  			// Create a connection
  			db.disconnect("conn1");
  			
  			// Test assertions
  			assertEquals("getConnection()", (c-1), db.getConnections());
   		}
	}
}