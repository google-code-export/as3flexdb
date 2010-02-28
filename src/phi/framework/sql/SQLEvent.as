package phi.framework.sql
{
	import flash.events.Event;
	
	public class SQLEvent extends Event
	{
		static public const SQL_RESULT :String = "sqlResult";
		
		public var result :SQLResult;
		
		public function SQLEvent(bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(SQL_RESULT, bubbles, cancelable);
		}
	}
}