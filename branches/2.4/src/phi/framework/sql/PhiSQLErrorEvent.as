package phi.framework.sql
{
	import flash.events.Event;

	public class PhiSQLErrorEvent extends Event
	{
		static public const SQL_ERROR :String = "sqlError";
		
		public var error  :String = "";
		
		public function PhiSQLErrorEvent(bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(SQL_ERROR, bubbles, cancelable);
		}
	}
}