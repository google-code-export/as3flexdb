package phi.framework.sql.services
{

	public class SQLCustomSerivice extends SQLAbstractService 
		implements ISQLService
	{
		public function SQLCustomSerivice(destination:String="", source:String="")
		{
			super(destination, source);
		}
		
		public function set destination( value:String ):void
		{
			_destination = value;
		}
		
		public function set source( value:String ):void
		{
			_source = value;
		}
	}
}