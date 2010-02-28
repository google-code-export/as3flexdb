<?php

/**
 * Main class.
 */
class AS3FlexDB
{
	var $NAME 		= "as3flexdb";
	var $VERSION	= "2.0.0";
	
	var $USERNAME	= "root";
	var $PASSWORD	= "root";
	
	var $SELECT		= "select";
	var $INSERT		= "insert";
	var $UPDATE		= "update";
	var $MULTIPLE	= "multiple";
	var $DELETE		= "delete";
	var $ERROR		= "error";
	
	/**
	 * Constructor.
	 */
	function AS3FlexDB() {}
	
	/**
     * Execute a SQL statement to databse.
     * @returns the result object.
     */
	function query($query, $host, $database, $type)
	{
		$res = new AS3FlexDBResult();
		$res->type = $type;
		$res->records = array();
		
		$rsConnectionID = $this->open($host);
		$rsResult = mysql_db_query($database, $query, $rsConnectionID);
		
		// Return the error
		if(!$rsResult)
		{
			$res->type = $this->ERROR;
			$res->error = mysql_error($rsConnectionID);
			
		   	return $res;
		}
		
		// Create proper result
		switch($type)
		{
			case $this->SELECT:
			{
				while($row = mysql_fetch_object($rsResult))
					array_push($res->records, $row);
			}
			break;
			
			case $this->INSERT:
			{
				$lastInsertID = mysql_insert_id($rsConnectionID);
				$res->lastInsertId = $lastInsertID;
			}
			break;
			
			default:
		}
		
		$this->close($rsConnectionID);
		return $res;
	}
	
	/**
	 * Execute multiple SQLs to database.
	 * @returns an array of arrays
	 */
	function queryAll($querys, $host, $database)
	{
		$res = new AS3FlexDBResult();
		$res->type = $this->MULTIPLE;
		$res->records = array();
		
		foreach($querys as $q)
		{
			$tmp = $this->query($q['q'], $host, $database, $q['option']);
			array_push($res->records, $tmp);
		}
		
		return $res;
	}
	
	/**
     * Open the connection to the database.
     * @returns the connection id.
     */
	function open($strHost) 
	{
   		$rsConnectionID = @mysql_connect($strHost, $this->USERNAME, $this->PASSWORD);
    	return $rsConnectionID;	
  	}
	
	/**
     * Close the connection to the database.
     * @returns a resource.
     */
  	function close($rsConnectionID) 
	{
    	$res = @mysql_close($rsConnectionID);
    	return $res;
  	}
	
	/**
     * Class name.
     * @returns a string that reprezent class name.
     */
	function getName()
	{
		return $this->NAME;
	}
	
	/**
     * Class version.
     * @returns a string that reprezent class version.
     */
	function getVersion()
	{
		return $this->VERSION;
	}
	
}

/**
 * Returned object.
 */
class AS3FlexDBResult
{
	var $type = 'select';
	var $records = array();
	var $error = '';
	var $lastInsertId = 0;
}

?>