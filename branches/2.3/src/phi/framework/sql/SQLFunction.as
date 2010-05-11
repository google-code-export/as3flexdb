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
			var result :String = name + "()"; 
			var parsedArgs :Array = [];
			
			if( args )
			{
				for each( var item :* in args )
					parsedArgs.push( itemToString( item ));
					
				result = name + "("+ parsedArgs.join(',') +")";
			}
			
			return result;
		}
		
		protected function itemToString( item:* ):String
		{
			var result :String = "";
			
			if( item is Number )
				result = Number(item).toString();
			else 
				if( item is SQLFunction )
					result = SQLFunction( item ).toString();
				else
					result = '"'+ String(item) +'"';
			
			return result;
		}
	}
}