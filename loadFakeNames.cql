
// connection info
//bash-3.2$ ./bin/cypher-shell -u neo4j -p TeslaPoc

// Create Indices
CREATE INDEX ON :Address(location);
CREATE INDEX ON :Address(lat, lng);
CREATE INDEX ON :Address(formatted_address);
CREATE INDEX ON :Email(email);
CREATE INDEX ON :Phone(phone);

CREATE INDEX ON :Customer(custId);
CREATE INDEX ON :Customer(lastName);
CREATE INDEX ON :Customer(lastName, firstName);



// row layout
//Number|GivenName|Surname|StreetAddress|City|State|ZipCode|EmailAddress|TelephoneNumber|Latitude|Longitude|NationalID
//1|Debbie|Lopez|2167 Kemper Lane|Morgan|UT|84050|DebbieELopez@teleworm.us|801-845-8240|41.010694|-111.742411|647-09-2661
//2|Walter|Quezada|410 Yorkie Lane|Savannah|GA|31401|WalterLQuezada@gustr.com|912-916-5323|32.0456|-81.09714|671-24-0561



// load and link customers, addresses, phones, emails

USING PERIODIC COMMIT 10000
LOAD CSV WITH HEADERS FROM "file:///Users/markquinsland/Downloads/fakeNames/fakeNames_3.txt" AS line
FIELDTERMINATOR '|'
 with line
//skip 80000
//limit 20000

MERGE (cust:Customer {custId:line.NationalID})
   ON CREATE
     SET cust.firstName = line.GivenName,
		     cust.lastName = line.Surname

		 // use the foreach-hack as an if statement for a conditional

		 // conditionally load addresses
		 FOREACH(ignoreMe IN CASE WHEN ( line.Latitude is not null and line.Longitude is not null) THEN [1] ELSE [] END |
				 MERGE (addr:Address {lat:toFloat(line.Latitude),lng:toFloat(line.Longitude)})
						ON CREATE
							SET addr.formatted_address=  line.StreetAddress + '' + line.City+ '' + line.State+ '' + line.ZipCode
				 MERGE (cust)-[:HOME_ADDRESS]-(addr)
						 )

		 // conditionally load email addresses
		 FOREACH(ignoreMe IN CASE WHEN ( line.EmailAddress is not null) THEN [1] ELSE [] END |
				 	MERGE (e:Email {email:line.EmailAddress})
				  MERGE (cust)-[:EMAIL]-(e)
							)

		 // conditionally load phone numbers
		 FOREACH(ignoreMe IN CASE WHEN ( line.TelephoneNumber is not null) THEN [1] ELSE [] END |
		     	MERGE (p:Phone {phone:line.TelephoneNumber})
				  MERGE (cust)-[:HOME_PHONE]-(p)
             );




create (robert:Name {name:'robert'})
create (bob:Name {name:'bob'})
create (rob:Name {name:'rob'})
create (bobby:Name {name:'bobby'})
create (bobbie:Name {name:'bobbie'})

create (robert)-[:AKA]->(bob)
create (robert)-[:AKA]->(rob)
create (robert)-[:AKA]->(bobby)
create (robert)-[:AKA]->(bobbie)

create (liza:Name {name:'liza'})
create (eliza:Name {name:'eliza'})
create (elise:Name {name:'elise'})
create (elyse:Name {name:'elyse'})
create (elisa:Name {name:'elisa'})

create (liz:Name {name:'liz'})
create (lisa:Name {name:'lisa'})
create (beth:Name {name:'beth'})
create (betsy:Name {name:'betsy'})
create (elizabeth:Name {name:'elizabeth'})

create (elizabeth)-[:AKA]->(liz)
create (elizabeth)-[:AKA]->(lisa)
create (elizabeth)-[:AKA]->(liza)
create (elizabeth)-[:AKA]->(beth)
create (elizabeth)-[:AKA]->(betsy)

create (elisa)-[:AKA]->(eliza)
create (elisa)-[:AKA]->(elyse)
create (elisa)-[:AKA]->(elise)

create (elisa)-[:AKA]->(lisa)
create (eliza)-[:AKA]->(lisa)
create (eliza)-[:AKA]->(liza)
