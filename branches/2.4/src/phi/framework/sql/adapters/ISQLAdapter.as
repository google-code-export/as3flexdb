package phi.framework.sql.adapters
{
	import mx.messaging.ChannelSet;
	
	public interface ISQLAdapter
	{
		function set host( value:String ):void;
		function get host():String;
		
		function set database( value:String ):void;
		function get database():String;
	}
}