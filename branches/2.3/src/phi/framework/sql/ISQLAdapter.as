package phi.framework.sql
{
	public interface ISQLAdapter
	{
		function set host( value:String ):void;
		function get host():String;
		function set database( value:String ):void;
		function get database():String;
		function get service():ISQLService;
	}
}