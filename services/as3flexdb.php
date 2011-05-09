<?php

/**
 * Main class.
 */
class AS3FlexDB
{
	protected $_name 		= "as3flexdb";
	protected $_version		= "2.0.0";	
	protected $_username	= "root";
	protected $_password	= "root";
	
	const SELECT	= "select";
	const INSERT	= "insert";
	const UPDATE	= "update";
	const MULTIPLE	= "multiple";
	const DELETE	= "delete";
	const ERROR		= "error";
	
	/**
	 * Constructor.
	 */
	function AS3FlexDB() {}
	
	/**
     * Execute a SQL statement.
     * @returns the result object.
     */
	function query($q, $host, $database)
	{
		$mysqli = new mysqli($host, $this->_username, $this->_password, $database);
		
		$rsResult = $mysqli->query( $q );
		
		$res = new AS3FlexDBResult();
		$res->type = $this->getType( $q );
		$res->records = array();
		
		// Return the error
		if(!$rsResult)
		{
			$res->type = AS3FlexDB::ERROR;
			$res->error = $mysqli->error;
 
		   	return $res;
		}
		
		// If all good
		switch( $res->type )
		{
			case AS3FlexDB::SELECT:
			{
				while($row = $rsResult->fetch_object())
					array_push($res->records, $row);
			}
			break;
 
			case AS3FlexDB::INSERT:
			{
				$res->lastInsertId = $mysqli->insert_id;
				$res->rowsAffected = $mysqli->affected_rows;
			}
			break;
			
			case AS3FlexDB::UPDATE:
			case AS3FlexDB::DELETE:
			{
				$res->rowsAffected = $mysqli->affected_rows;
			}
			break;
 
			default:
		}
		
		$mysqli->close();
		return $res;
	}
	
	/**
     * Execute multiple SQL statements comma separated.
     * @returns the result object.
     */
	function multipleQuery($queries, $host, $database)
	{
		$res 			= new AS3FlexDBResult();
		$res->type 		= AS3FlexDB::MULTIPLE;
		$res->records 	= array();
		
		$mysqli = new mysqli($host, $this->_username, $this->_password, $database);
		
		if ($mysqli->multi_query($queries)) 
		{
			$i = 0;
			do 
			{
				/* store first result set */
				if ($result = $mysqli->store_result()) 
				{
					$res->records[$i] = array();
					while ($row = $result->fetch_row())	
						array_push($res->records[$i], $row);
					
					$result->free();
				}
				$i++;
			} 
			while ($mysqli->next_result());
		}
		
		if($mysqli->errno)
		{
			$res->type = AS3FlexDB::ERROR;
			$res->error = $mysqli->error;
 
		   	return $res;
		}
		
		return $res;
	}
	
	/**
	 * Parse a query string.
	 * @returns SELECT, INSERT, UPDATE or DELETE
	 */
	function getType( $q )
	{
		$tmp = explode( " ", $q );
		return trim( strtolower($tmp[0]) );
	}
	
	/**
     * Class name.
     * @returns a string that reprezents class name.
     */
	function getName()
	{
		return $this->_name;
	}
	
	/**
     * Class version.
     * @returns a string that reprezents class version.
     */
	function getVersion()
	{
		return $this->_version;
	}
	
}

/**
 * Returned object.
 */
class AS3FlexDBResult
{
	var $type = AS3FlexDB::SELECT;
	var $records = array();
	var $error = '';
	var $lastInsertId = 0;
	var $rowsAffected = 0;
}

?>