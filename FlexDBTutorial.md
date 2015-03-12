Take a look at [AS3FlexDB Tutorial 1](http://itutorials.ro/viewtopic.php?f=9&t=7) tutorial from [iTutorials.ro](http://itutorials.ro/)

## Simple example ##

All you need to load a table (for ex. "users") into a datagrid after you have install amfphp and set "services-config.xml" correctly is :

```
<?xml version="1.0" encoding="utf-8"?>
<mx:Application
	layout="vertical"
	xmlns:phi="phi.db.*"
	xmlns:mx="http://www.adobe.com/2006/mxml">

	<mx:DataGrid
		id="dg1"
		width="100%"
		height="100%"
		dataProvider="{q1.Records}">
		<mx:columns>
			<mx:DataGridColumn dataField="fname" headerText="First Name"/>
			<mx:DataGridColumn dataField="lname" headerText="Last Name"/>
			<mx:DataGridColumn dataField="password" headerText="Password"/>
		</mx:columns>
	</mx:DataGrid>
	
	<phi:ConnectionData id="c1" name="mxml_conn1" host="localhost" db="test" username="root" password="root" />
	<phi:Database id="db1" connection="{c1}" />
	<phi:Query id="q1" database="{db1}" q="SELECT * FROM users WHERE 1" />
	<phi:QueryExecute id="q1ex" query="{q1}" />
</mx:Application>
```

Table structures is:

```
CREATE TABLE `users` (
  `id` int(5) NOT NULL auto_increment,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `fname` varchar(255) NOT NULL,
  `lname` varchar(255) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1;
```