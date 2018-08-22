# deduping
Experimenting with different ways to use Neo4j to dedup customer data


# Record Source
These files were originally created from https://www.fakenamegenerator.com/order.php    
I chose the pipe-delimted option and the following fields:

// row layout
//Number|GivenName|Surname|StreetAddress|City|State|ZipCode|EmailAddress|TelephoneNumber|Latitude|Longitude|NationalID
//1|Debbie|Lopez|2167 Kemper Lane|Morgan|UT|84050|DebbieELopez@teleworm.us|801-845-8240|41.010694|-111.742411|647-09-2661
//2|Walter|Quezada|410 Yorkie Lane|Savannah|GA|31401|WalterLQuezada@gustr.com|912-916-5323|32.0456|-81.09714|671-24-0561

The actual loading script is fairly simple.  It uses the foreach-hack to conditionally create links to addresses, emails, and phone numbers.  It was intended to quickly load/reload the initial set of records - considered the GOLD records that will be deduped against.

I was running on a memory-constrained macbook so I typically loaded only 20k rows at a time - but with some tweaking of memory config, it should do 100k in a minute or so.


