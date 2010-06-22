package phi.framework.sql
{
	import flash.events.Event;
	
	public class PhiSQLEvent extends Event
	{
		static public const SQL_RESULT :String = "sqlResult";
		
		public var result :PhiSQLResult;
		
		public function PhiSQLEvent(bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(SQL_RESULT, bubbles, cancelable);
		}
	}
}