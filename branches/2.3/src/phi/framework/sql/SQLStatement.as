package phi.framework.sql
{
	import flash.events.EventDispatcher;
	
	import mx.managers.CursorManager;
	import mx.rpc.AsyncResponder;
	import mx.rpc.AsyncToken;

	/**
	 *  Dispatched after the SQL statement was executed.
	 * 
	 * <P>The SQL_RESULT event is dispatched when the 
	 * <code>execute()</code> method is called.<BR>
	 * At the time when this event is sent, the <code>SQLStatement</code> object has been
	 * retrieve the records if a SELECT statements was execute or the last inserted id
	 * if a INSERT statement was execute.</P>
	 * 
	 * @eventType phi.framework.sql.SQLEvent
	 */
	[Event(name="sqlResult", type="phi.framework.sql.SQLEvent")]
	
	/**
	 *  Dispatched if any error occurs.
	 * 
	 * @eventType phi.framework.sql.SQLErrorEvent
	 */
	[Event(name="sqlError", type="phi.framework.sql.SQLErrorEvent")]

	
	public class SQLStatement extends EventDispatcher
	{
		protected var _sqlConnection :SQLConnection = null;
		protected var _text :String;
		protected var _parameters :Array = new Array();
		protected var _token :Object = new Object();
		protected var _result :SQLResult;
		protected var _waitingStack :Array = new Array();
		protected var _isExecuting :Boolean = false;
		
		public function SQLStatement( text:String="" )
		{
			this.text = text;
			this._result = new SQLResult( this );
		}
		
		public function set text( value:String ):void
		{
			_text = value;
		}
		
		public function get text():String
		{
			return _text;
		}
		
		public function set token( value:Object ):void
		{
			_token = value;
		}
		
		public function get token():Object
		{
			return _token;
		}
		
		public function get parameters():Array
		{
			return _parameters;
		}
		
		public function set sqlConnection( value:SQLConnection ):void
		{
			_sqlConnection = value;	
		}
		
		public function get sqlConnection():SQLConnection
		{
			return _sqlConnection;	
		}
		
		public function get isExecuting():Boolean
		{
			return _isExecuting;
		}
		
		public function set isExecuting( value:Boolean ):void
		{
			_isExecuting = value;
		}
		
		public function clearParameters():void
		{
			_parameters = new Array();
		}
		
		public function getResult():SQLResult
		{
			return _result;
		}
		
		public function execute( sql:String=""):void
		{
			var host :String = sqlConnection.sqlAdapter.host;
			var database :String = sqlConnection.sqlAdapter.database;
			var token :AsyncToken = null
			var q :String = "";
			
			if( sql == "" )
				q = substituteText();
			else
				q = sql;
			
			if( isExecuting )
			{
				_waitingStack.push( q );
			}
			else
			{
				
				token = sqlConnection.remoteObj.query( q, host, database );
				CursorManager.setBusyCursor();
			
				token.addResponder(
					new AsyncResponder(
						resultHandler,
						faultHandler,
						q
					)
				);
			}
			
			return;
		}
		
		protected function executeNext():void
		{
			if( _waitingStack.length > 0 )
				execute( _waitingStack.shift() );
		}
		
		protected function substituteText():String
		{
			var i:Number = 0;
			var result :String = text;
			var regEx :RegExp = /\?/;
			
			for ( i=0; i<parameters.length; i++ )
				result = result.replace( regEx, '"' + parameters[i] + '"' );
			
			return result;
		}
		
		//-----------------------------------------
		// Async handlers
		//-----------------------------------------
		
		protected function resultHandler( data:Object, token:Object ):void
		{
			CursorManager.removeBusyCursor();
			
			var resultType :String = data.result.type;
			
			if( resultType == "error" )
			{
				var errorEvent :SQLErrorEvent = new SQLErrorEvent();
				errorEvent.error = data.result.error as String;
				
				dispatchEvent( errorEvent );
				return;
			}
			
			// If no error
			var event	:SQLEvent = new SQLEvent();	
			var result	:SQLResult = new SQLResult( this, data.result, String( token ) );
			result.token = token;
						
			event.result = result;
			dispatchEvent( event );
			
			isExecuting = false;
			
			executeNext();
			return;
		}
		
		protected function faultHandler( info:Object, token:Object ):void
		{
			CursorManager.removeBusyCursor();
			
			isExecuting = false;
			executeNext();
		}
	}
}