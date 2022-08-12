$temp=$ARGV[0];
$wind=$ARGV[1];
$hum=$ARGV[2];

format STDOUT =
Real Feel = @##.## deg F  @<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
$rf,$comment
.

if($temp < 50 )
{
   $rf = 35.74+(.6215*$temp)-(35.75*($wind**.16))+(.4275*($temp*($wind**.16)));
   
   if($rf > 32) {$comment="No Danger"};
   if($rf < 32) {$comment="Frostbite in 30 mins"};
   if($rf < -19) {$comment="Frostbite in 10 mins"};
   if($rf < -48) {$comment="Frostbite in 5 mins"};
   select STDOUT;
   write;
}
else
{
	 $rf = (2.04901523*$temp)
	       + (10.14333127*$hum) 
	       - (0.22475541*$temp*$hum) 
	       - (.00683783*($temp**2))
	       - (.05481717*($hum**2)) 
	       + (.00122874*($temp**2)*$hum)
	       + (.00085282*$temp*($hum**2)) 
	       - (.00000199*($temp**2)*($hum**2))
	       - 42.379;
	
	$comment="No Danger";
	if($rf > 82) {$comment="Heat Category 2"};
  if($rf > 85) {$comment="Heat Category 3"};
  if($rf > 88) {$comment="Heat Category 4"};
  if($rf > 90) {$comment="Heat Category 5"};
  select STDOUT;
  write; 
}        
	       
