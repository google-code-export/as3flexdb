package phi.framework.sql
{
	public class SQLFunction
	{
		public var name :String;
		public var args :Array;
		
		public function SQLFunction( name:String, args:Array=null )
		{
			this.name = name;
			this.args = args;
		}
		
		public function toString():String
		{
			var result :String = name + "();"; 
			
			if( args )
				result = name + "("+ args.join(',') +")";  
			
			return result;
		}
	}
}