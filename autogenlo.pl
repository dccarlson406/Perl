#ARG 0 is CSV file that has been sorted by TAG number.
open(IN,$ARGV[0]) || die ("Could not open $file!");
@lines=<IN>;
close(IN);

#Create database of points to be tested. Array 'points' is an array of records.
#Output filename = LL_NNCCDD_NNCCDD.tdbm  NNCCDD = NodeNumber, ChassisNumber, CardNumber

foreach $line (@lines){
	$line =~ s/\s+$//;  				#Eliminate end of line characters.
  @inline=split(',',$line);
    $testpoint ={
   	  PNTNAME	=> $inline[0],
   	  TAG     => $inline[1],
   	  IN0     => $inline[2],
   	  IN25    => $inline[3],
   	  IN50    => $inline[4],
   	  IN75    => $inline[5],
   	  IN100   => $inline[6],
   	  EXP0    => $inline[7],
   	  EXP25   => $inline[8],
   	  EXP50   => $inline[9],
   	  EXP75   => $inline[10],
   	  EXP100  => $inline[11],
   	  TOL     => $inline[12],
   };
  push(@points, $testpoint); 
}
$size=@points;

#Fill in TDBM template 2 cards at a time using points->TAG to determine cards to test.
#Account for gaps in card and duplicate points under test.

while($size > 0){
	
  for($i=0;$i<16;$i++){			#Initialize all points in the TDBM to AITEST1, set and verify 0
    	$pt[$i]="AITEST1";		#This acts as a filler if there are channels in the card under test
    	$tol[$i]=0;						#That do not have point names assigned to them.
    	$in1[$i]=0;
    	$in2[$i]=0;
    	$in3[$i]=0;
    	$in4[$i]=0;
    	$in5[$i]=0;
    	$verify1[$i]=0;
    	$verify2[$i]=0;
    	$verify3[$i]=0;
    	$verify4[$i]=0;
    	$verify5[$i]=0;
  }
  
  $cardnum=0;								#Initialize temporary variables.
  $card="";
  $out1="None";
  $out2="None";
  @dups = ();
  
  while($cardnum<3 && $size>0){
  	@tag=split("_",$points[0]->{TAG});
    if($tag[3] ne $card){
    	$cardnum++;
    	$card=$tag[3];
    	if($cardnum==1){	$out1=$tag[1].$tag[2].$tag[3];	}			#Track the card tag to determine TDBM file name.
    	if($cardnum==2){	$out2=$tag[1].$tag[2].$tag[3];	}
    	if($cardnum>2){	next;	}
    }
    
    $point=shift(@points);
    $size=@points;
    @tag=split("_",$point->{TAG});
    if($cardnum==1){	$chan=$tag[4];    }
    if($cardnum==2){	$chan=$tag[4]+8;  }
    if($pt[$chan] ne "AITEST1"){								#Check for duplicates if it is a duplicate, push it to @dups array
    	push (@dups,$point);											#@dups array then used in verification section only in TDBM generation.
    	next;
    }
         $pt[$chan]=$point->{PNTNAME};
        $tol[$chan]=$point->{TOL};    
        $in1[$chan]=$point->{IN0};    
        $in2[$chan]=$point->{IN25};   
        $in3[$chan]=$point->{IN50};   
        $in4[$chan]=$point->{IN75};   
        $in5[$chan]=$point->{IN100};  
    $verify1[$chan]=$point->{EXP0};   
    $verify2[$chan]=$point->{EXP25};  
    $verify3[$chan]=$point->{EXP50};  
    $verify4[$chan]=$point->{EXP75};  
    $verify5[$chan]=$point->{EXP100}; 
    
  }
  gentdbm();                      #Generate the TDBM file
}


sub gentdbm {
$outfile="LL_".$out1."_".$out2.".tdbm";
open(OUT,">$outfile");
print ("$outfile\n");

$c=1;
print OUT "DB='NMP1'\n";
print OUT "LF='$logfile'\n";
print OUT "LO='F'\n";
print OUT "CSV='1'\n";
print OUT " &INLIST\n";
print OUT "FC($c)='S',  PT($c)='DASTST01A01', IV($c)= $in1[0],  QL($c)='GA', ST($c)= 0, ET($c)= 0, \n"; $c++;
print OUT "FC($c)='S',  PT($c)='DASTST01A02', IV($c)= $in1[1],  QL($c)='GA', ST($c)= 0, ET($c)= 0, \n"; $c++;
print OUT "FC($c)='S',  PT($c)='DASTST01A03', IV($c)= $in1[2],  QL($c)='GA', ST($c)= 0, ET($c)= 0, \n"; $c++;
print OUT "FC($c)='S',  PT($c)='DASTST01A04', IV($c)= $in1[3],  QL($c)='GA', ST($c)= 0, ET($c)= 0, \n"; $c++;
print OUT "FC($c)='S',  PT($c)='DASTST01A05', IV($c)= $in1[4],  QL($c)='GA', ST($c)= 0, ET($c)= 0, \n"; $c++;
print OUT "FC($c)='S',  PT($c)='DASTST01A06', IV($c)= $in1[5],  QL($c)='GA', ST($c)= 0, ET($c)= 0, \n"; $c++;
print OUT "FC($c)='S',  PT($c)='DASTST01A07', IV($c)= $in1[6],  QL($c)='GA', ST($c)= 0, ET($c)= 0, \n"; $c++;
print OUT "FC($c)='S',  PT($c)='DASTST01A08', IV($c)= $in1[7],  QL($c)='GA', ST($c)= 0, ET($c)= 0, \n"; $c++;
print OUT "FC($c)='S',  PT($c)='DASTST01A09', IV($c)= $in1[8],  QL($c)='GA', ST($c)= 0, ET($c)= 0, \n"; $c++;
print OUT "FC($c)='S', PT($c)='DASTST01A10', IV($c)= $in1[9],  QL($c)='GA', ST($c)= 0, ET($c)= 0, \n"; $c++;
print OUT "FC($c)='S', PT($c)='DASTST01A11', IV($c)= $in1[10], QL($c)='GA', ST($c)= 0, ET($c)= 0, \n"; $c++;
print OUT "FC($c)='S', PT($c)='DASTST01A12', IV($c)= $in1[11], QL($c)='GA', ST($c)= 0, ET($c)= 0, \n"; $c++;
print OUT "FC($c)='S', PT($c)='DASTST01A13', IV($c)= $in1[12], QL($c)='GA', ST($c)= 0, ET($c)= 0, \n"; $c++;
print OUT "FC($c)='S', PT($c)='DASTST01A14', IV($c)= $in1[13], QL($c)='GA', ST($c)= 0, ET($c)= 0, \n"; $c++;
print OUT "FC($c)='S', PT($c)='DASTST01A15', IV($c)= $in1[14], QL($c)='GA', ST($c)= 0, ET($c)= 0, \n"; $c++;
print OUT "FC($c)='S', PT($c)='DASTST01A16', IV($c)= $in1[15], QL($c)='GA', ST($c)= 0, ET($c)= 0, \n"; $c++;

print OUT "CO='Verify 0%', \n";
print OUT "FC($c)='V', PT($c)='$pt[0]',  EV($c)= $verify1[0], EQ($c)='R', ST($c)= 20, ET($c)= 20,  AT($c)=$tol[0],\n";   $c++;
print OUT "FC($c)='V', PT($c)='$pt[1]',  EV($c)= $verify1[1], EQ($c)='R', ST($c)= 20, ET($c)= 20,  AT($c)=$tol[1],\n";   $c++;
print OUT "FC($c)='V', PT($c)='$pt[2]',  EV($c)= $verify1[2], EQ($c)='R', ST($c)= 20, ET($c)= 20,  AT($c)=$tol[2],\n";   $c++;
print OUT "FC($c)='V', PT($c)='$pt[3]',  EV($c)= $verify1[3], EQ($c)='R', ST($c)= 20, ET($c)= 20,  AT($c)=$tol[3],\n";   $c++;
print OUT "FC($c)='V', PT($c)='$pt[4]',  EV($c)= $verify1[4], EQ($c)='R', ST($c)= 20, ET($c)= 20,  AT($c)=$tol[4],\n";   $c++;
print OUT "FC($c)='V', PT($c)='$pt[5]',  EV($c)= $verify1[5], EQ($c)='R', ST($c)= 20, ET($c)= 20,  AT($c)=$tol[5],\n";   $c++;
print OUT "FC($c)='V', PT($c)='$pt[6]',  EV($c)= $verify1[6], EQ($c)='R', ST($c)= 20, ET($c)= 20,  AT($c)=$tol[6],\n";   $c++;
print OUT "FC($c)='V', PT($c)='$pt[7]',  EV($c)= $verify1[7], EQ($c)='R', ST($c)= 20, ET($c)= 20,  AT($c)=$tol[7],\n";   $c++;
print OUT "FC($c)='V', PT($c)='$pt[8]',  EV($c)= $verify1[8], EQ($c)='R', ST($c)= 20, ET($c)= 20,  AT($c)=$tol[8],\n";   $c++;
print OUT "FC($c)='V', PT($c)='$pt[9]',  EV($c)= $verify1[9], EQ($c)='R', ST($c)= 20, ET($c)= 20,  AT($c)=$tol[9],\n";   $c++;
print OUT "FC($c)='V', PT($c)='$pt[10]', EV($c)= $verify1[10], EQ($c)='R', ST($c)= 20, ET($c)= 20, AT($c)=$tol[10],\n";  $c++;
print OUT "FC($c)='V', PT($c)='$pt[11]', EV($c)= $verify1[11], EQ($c)='R', ST($c)= 20, ET($c)= 20, AT($c)=$tol[11],\n";  $c++;
print OUT "FC($c)='V', PT($c)='$pt[12]', EV($c)= $verify1[12], EQ($c)='R', ST($c)= 20, ET($c)= 20, AT($c)=$tol[12],\n";  $c++;
print OUT "FC($c)='V', PT($c)='$pt[13]', EV($c)= $verify1[13], EQ($c)='R', ST($c)= 20, ET($c)= 20, AT($c)=$tol[13],\n";  $c++;
print OUT "FC($c)='V', PT($c)='$pt[14]', EV($c)= $verify1[14], EQ($c)='R', ST($c)= 20, ET($c)= 20, AT($c)=$tol[14],\n";  $c++;
print OUT "FC($c)='V', PT($c)='$pt[15]', EV($c)= $verify1[15], EQ($c)='R', ST($c)= 20, ET($c)= 20, AT($c)=$tol[15],\n";  $c++;

foreach $dup (@dups){
	print OUT "FC($c)='V', PT($c)='$dup->{PNTNAME}', EV($c)= $dup->{EXP0}, EQ($c)='R', ST($c)= 20, ET($c)= 20, AT($c)=$dup->{TOL},\n";  $c++;
}

print OUT "CO='Set 25%', \n";
print OUT "FC($c)='S', PT($c)='DASTST01A01', IV($c)= $in2[0],  ST($c)= 25, ET($c)= 25,\n";   $c++;
print OUT "FC($c)='S', PT($c)='DASTST01A02', IV($c)= $in2[1],  ST($c)= 25, ET($c)= 25,\n";   $c++;
print OUT "FC($c)='S', PT($c)='DASTST01A03', IV($c)= $in2[2],  ST($c)= 25, ET($c)= 25,\n";   $c++;
print OUT "FC($c)='S', PT($c)='DASTST01A04', IV($c)= $in2[3],  ST($c)= 25, ET($c)= 25,\n";   $c++;
print OUT "FC($c)='S', PT($c)='DASTST01A05', IV($c)= $in2[4],  ST($c)= 25, ET($c)= 25,\n";   $c++;
print OUT "FC($c)='S', PT($c)='DASTST01A06', IV($c)= $in2[5],  ST($c)= 25, ET($c)= 25,\n";   $c++;
print OUT "FC($c)='S', PT($c)='DASTST01A07', IV($c)= $in2[6],  ST($c)= 25, ET($c)= 25,\n";   $c++;
print OUT "FC($c)='S', PT($c)='DASTST01A08', IV($c)= $in2[7],  ST($c)= 25, ET($c)= 25,\n";   $c++;
print OUT "FC($c)='S', PT($c)='DASTST01A09', IV($c)= $in2[8],  ST($c)= 25, ET($c)= 25,\n";   $c++;
print OUT "FC($c)='S', PT($c)='DASTST01A10', IV($c)= $in2[9],  ST($c)= 25, ET($c)= 25,\n";   $c++;
print OUT "FC($c)='S', PT($c)='DASTST01A11', IV($c)= $in2[10], ST($c)= 25, ET($c)= 25,\n";   $c++;
print OUT "FC($c)='S', PT($c)='DASTST01A12', IV($c)= $in2[11], ST($c)= 25, ET($c)= 25,\n";   $c++;
print OUT "FC($c)='S', PT($c)='DASTST01A13', IV($c)= $in2[12], ST($c)= 25, ET($c)= 25,\n";   $c++;
print OUT "FC($c)='S', PT($c)='DASTST01A14', IV($c)= $in2[13], ST($c)= 25, ET($c)= 25,\n";   $c++;
print OUT "FC($c)='S', PT($c)='DASTST01A15', IV($c)= $in2[14], ST($c)= 25, ET($c)= 25,\n";   $c++;
print OUT "FC($c)='S', PT($c)='DASTST01A16', IV($c)= $in2[15], ST($c)= 25, ET($c)= 25,\n";   $c++;

print OUT "CO='Verify 25%', \n";
print OUT "FC($c)='V', PT($c)='$pt[0]',  EV($c)=$verify2[0],  EQ(49)='G', ST($c)= 45, ET($c)= 45, AT($c)=$tol[0],\n";   $c++;
print OUT "FC($c)='V', PT($c)='$pt[1]',  EV($c)=$verify2[1],  EQ(50)='G', ST($c)= 45, ET($c)= 45, AT($c)=$tol[1],\n";   $c++;
print OUT "FC($c)='V', PT($c)='$pt[2]',  EV($c)=$verify2[2],  EQ(51)='G', ST($c)= 45, ET($c)= 45, AT($c)=$tol[2],\n";   $c++;
print OUT "FC($c)='V', PT($c)='$pt[3]',  EV($c)=$verify2[3],  EQ(52)='G', ST($c)= 45, ET($c)= 45, AT($c)=$tol[3],\n";   $c++;
print OUT "FC($c)='V', PT($c)='$pt[4]',  EV($c)=$verify2[4],  EQ(53)='G', ST($c)= 45, ET($c)= 45, AT($c)=$tol[4],\n";   $c++;
print OUT "FC($c)='V', PT($c)='$pt[5]',  EV($c)=$verify2[5],  EQ(54)='G', ST($c)= 45, ET($c)= 45, AT($c)=$tol[5],\n";   $c++;
print OUT "FC($c)='V', PT($c)='$pt[6]',  EV($c)=$verify2[6],  EQ(55)='G', ST($c)= 45, ET($c)= 45, AT($c)=$tol[6],\n";   $c++;
print OUT "FC($c)='V', PT($c)='$pt[7]',  EV($c)=$verify2[7],  EQ(56)='G', ST($c)= 45, ET($c)= 45, AT($c)=$tol[7],\n";   $c++;
print OUT "FC($c)='V', PT($c)='$pt[8]',  EV($c)=$verify2[8],  EQ(57)='G', ST($c)= 45, ET($c)= 45, AT($c)=$tol[8],\n";   $c++;
print OUT "FC($c)='V', PT($c)='$pt[9]',  EV($c)=$verify2[9],  EQ(58)='G', ST($c)= 45, ET($c)= 45, AT($c)=$tol[9],\n";   $c++;
print OUT "FC($c)='V', PT($c)='$pt[10]', EV($c)=$verify2[10], EQ(59)='G', ST($c)= 45, ET($c)= 45, AT($c)=$tol[10],\n";  $c++;
print OUT "FC($c)='V', PT($c)='$pt[11]', EV($c)=$verify2[11], EQ(60)='G', ST($c)= 45, ET($c)= 45, AT($c)=$tol[11],\n";  $c++;
print OUT "FC($c)='V', PT($c)='$pt[12]', EV($c)=$verify2[12], EQ(61)='G', ST($c)= 45, ET($c)= 45, AT($c)=$tol[12],\n";  $c++;
print OUT "FC($c)='V', PT($c)='$pt[13]', EV($c)=$verify2[13], EQ(62)='G', ST($c)= 45, ET($c)= 45, AT($c)=$tol[13],\n";  $c++;
print OUT "FC($c)='V', PT($c)='$pt[14]', EV($c)=$verify2[14], EQ(63)='G', ST($c)= 45, ET($c)= 45, AT($c)=$tol[14],\n";  $c++;
print OUT "FC($c)='V', PT($c)='$pt[15]', EV($c)=$verify2[15], EQ(64)='G', ST($c)= 45, ET($c)= 45, AT($c)=$tol[15],\n";  $c++;

foreach $dup (@dups){
	print OUT "FC($c)='V', PT($c)='$dup->{PNTNAME}', EV($c)= $dup->{EXP25}, EQ($c)='R', ST($c)= 20, ET($c)= 20, AT($c)=$dup->{TOL},\n";  $c++;
}

print OUT "CO='Set 50%', \n";
print OUT "FC($c)='S', PT($c)='DASTST01A01', IV($c)=$in3[0],   ST($c)= 50, ET($c)= 50,\n";   $c++;
print OUT "FC($c)='S', PT($c)='DASTST01A02', IV($c)=$in3[1],   ST($c)= 50, ET($c)= 50,\n";   $c++;
print OUT "FC($c)='S', PT($c)='DASTST01A03', IV($c)=$in3[2],   ST($c)= 50, ET($c)= 50,\n";   $c++;
print OUT "FC($c)='S', PT($c)='DASTST01A04', IV($c)=$in3[3],   ST($c)= 50, ET($c)= 50,\n";   $c++;
print OUT "FC($c)='S', PT($c)='DASTST01A05', IV($c)=$in3[4],   ST($c)= 50, ET($c)= 50,\n";   $c++;
print OUT "FC($c)='S', PT($c)='DASTST01A06', IV($c)=$in3[5],   ST($c)= 50, ET($c)= 50,\n";   $c++;
print OUT "FC($c)='S', PT($c)='DASTST01A07', IV($c)=$in3[6],   ST($c)= 50, ET($c)= 50,\n";   $c++;
print OUT "FC($c)='S', PT($c)='DASTST01A08', IV($c)=$in3[7],   ST($c)= 50, ET($c)= 50,\n";   $c++;
print OUT "FC($c)='S', PT($c)='DASTST01A09', IV($c)=$in3[8],   ST($c)= 50, ET($c)= 50,\n";   $c++;
print OUT "FC($c)='S', PT($c)='DASTST01A10', IV($c)=$in3[9],   ST($c)= 50, ET($c)= 50,\n";   $c++;
print OUT "FC($c)='S', PT($c)='DASTST01A11', IV($c)=$in3[10],  ST($c)= 50, ET($c)= 50,\n";   $c++;
print OUT "FC($c)='S', PT($c)='DASTST01A12', IV($c)=$in3[11],  ST($c)= 50, ET($c)= 50,\n";   $c++;
print OUT "FC($c)='S', PT($c)='DASTST01A13', IV($c)=$in3[12],  ST($c)= 50, ET($c)= 50,\n";   $c++;
print OUT "FC($c)='S', PT($c)='DASTST01A14', IV($c)=$in3[13],  ST($c)= 50, ET($c)= 50,\n";   $c++;
print OUT "FC($c)='S', PT($c)='DASTST01A15', IV($c)=$in3[14],  ST($c)= 50, ET($c)= 50,\n";   $c++;
print OUT "FC($c)='S', PT($c)='DASTST01A16', IV($c)=$in3[15],  ST($c)= 50, ET($c)= 50,\n";   $c++;

print OUT "CO='Verify 50%', \n";
print OUT "FC($c)='V', PT($c)='$pt[0]',  EV($c)=$verify3[0],  ST($c)= 70, ET($c)= 70, AT($c)=$tol[0],\n";  $c++;
print OUT "FC($c)='V', PT($c)='$pt[1]',  EV($c)=$verify3[1],  ST($c)= 70, ET($c)= 70, AT($c)=$tol[1],\n";  $c++;
print OUT "FC($c)='V', PT($c)='$pt[2]',  EV($c)=$verify3[2],  ST($c)= 70, ET($c)= 70, AT($c)=$tol[2],\n";  $c++;
print OUT "FC($c)='V', PT($c)='$pt[3]',  EV($c)=$verify3[3],  ST($c)= 70, ET($c)= 70, AT($c)=$tol[3],\n";  $c++;
print OUT "FC($c)='V', PT($c)='$pt[4]',  EV($c)=$verify3[4],  ST($c)= 70, ET($c)= 70, AT($c)=$tol[4],\n";  $c++;
print OUT "FC($c)='V', PT($c)='$pt[5]',  EV($c)=$verify3[5],  ST($c)= 70, ET($c)= 70, AT($c)=$tol[5],\n";  $c++;
print OUT "FC($c)='V', PT($c)='$pt[6]',  EV($c)=$verify3[6],  ST($c)= 70, ET($c)= 70, AT($c)=$tol[6],\n";  $c++;
print OUT "FC($c)='V', PT($c)='$pt[7]',  EV($c)=$verify3[7],  ST($c)= 70, ET($c)= 70, AT($c)=$tol[7],\n";  $c++;
print OUT "FC($c)='V', PT($c)='$pt[8]',  EV($c)=$verify3[8],  ST($c)= 70, ET($c)= 70, AT($c)=$tol[8],\n";  $c++;
print OUT "FC($c)='V', PT($c)='$pt[9]',  EV($c)=$verify3[9],  ST($c)= 70, ET($c)= 70, AT($c)=$tol[9],\n";  $c++;
print OUT "FC($c)='V', PT($c)='$pt[10]', EV($c)=$verify3[10], ST($c)= 70, ET($c)= 70, AT($c)=$tol[10],\n"; $c++;
print OUT "FC($c)='V', PT($c)='$pt[11]', EV($c)=$verify3[11], ST($c)= 70, ET($c)= 70, AT($c)=$tol[11],\n"; $c++;
print OUT "FC($c)='V', PT($c)='$pt[12]', EV($c)=$verify3[12], ST($c)= 70, ET($c)= 70, AT($c)=$tol[12],\n"; $c++;
print OUT "FC($c)='V', PT($c)='$pt[13]', EV($c)=$verify3[13], ST($c)= 70, ET($c)= 70, AT($c)=$tol[13],\n"; $c++;
print OUT "FC($c)='V', PT($c)='$pt[14]', EV($c)=$verify3[14], ST($c)= 70, ET($c)= 70, AT($c)=$tol[14],\n"; $c++;
print OUT "FC($c)='V', PT($c)='$pt[15]', EV($c)=$verify3[15], ST($c)= 70, ET($c)= 70, AT($c)=$tol[15],\n"; $c++;

foreach $dup (@dups){
	print OUT "FC($c)='V', PT($c)='$dup->{PNTNAME}', EV($c)= $dup->{EXP50}, EQ($c)='R', ST($c)= 20, ET($c)= 20, AT($c)=$dup->{TOL},\n";  $c++;
}

print OUT "CO='Set 75 %', \n";
print OUT "FC($c)='S', PT($c)='DASTST01A01', IV($c)= $in4[0],  ST($c)= 75, ET($c)= 75,\n";  $c++;
print OUT "FC($c)='S', PT($c)='DASTST01A02', IV($c)= $in4[1],  ST($c)= 75, ET($c)= 75,\n";  $c++;
print OUT "FC($c)='S', PT($c)='DASTST01A03', IV($c)= $in4[2],  ST($c)= 75, ET($c)= 75,\n";  $c++;
print OUT "FC($c)='S', PT($c)='DASTST01A04', IV($c)=$in4[3],  ST($c)= 75, ET($c)= 75,\n";     $c++;
print OUT "FC($c)='S', PT($c)='DASTST01A05', IV($c)=$in4[4],  ST($c)= 75, ET($c)= 75,\n";     $c++;
print OUT "FC($c)='S', PT($c)='DASTST01A06', IV($c)=$in4[5],  ST($c)= 75, ET($c)= 75,\n";     $c++;
print OUT "FC($c)='S', PT($c)='DASTST01A07', IV($c)=$in4[6],  ST($c)= 75, ET($c)= 75,\n";     $c++;
print OUT "FC($c)='S', PT($c)='DASTST01A08', IV($c)=$in4[7],  ST($c)= 75, ET($c)= 75,\n";     $c++;
print OUT "FC($c)='S', PT($c)='DASTST01A09', IV($c)=$in4[8],  ST($c)= 75, ET($c)= 75,\n";     $c++;
print OUT "FC($c)='S', PT($c)='DASTST01A10', IV($c)=$in4[9],  ST($c)= 75, ET($c)= 75,\n";     $c++;
print OUT "FC($c)='S', PT($c)='DASTST01A11', IV($c)=$in4[10], ST($c)= 75, ET($c)= 75,\n";     $c++;
print OUT "FC($c)='S', PT($c)='DASTST01A12', IV($c)=$in4[11], ST($c)= 75, ET($c)= 75,\n";     $c++;
print OUT "FC($c)='S', PT($c)='DASTST01A13', IV($c)=$in4[12], ST($c)= 75, ET($c)= 75,\n";     $c++;
print OUT "FC($c)='S', PT($c)='DASTST01A14', IV($c)=$in4[13], ST($c)= 75, ET($c)= 75,\n";     $c++;
print OUT "FC($c)='S', PT($c)='DASTST01A15', IV($c)=$in4[14], ST($c)= 75, ET($c)= 75,\n";     $c++;
print OUT "FC($c)='S', PT($c)='DASTST01A16', IV($c)=$in4[15], ST($c)= 75, ET($c)= 75,\n";     $c++;

print OUT "CO='Verify 75%', \n";
print OUT "FC($c)='V', PT($c)='$pt[0]',  EV($c)=$verify4[0],  ST($c)= 95, ET($c)= 95, AT($c)=$tol[0],\n";    $c++;
print OUT "FC($c)='V', PT($c)='$pt[1]',  EV($c)=$verify4[1],  ST($c)= 95, ET($c)= 95, AT($c)=$tol[1],\n";    $c++;
print OUT "FC($c)='V', PT($c)='$pt[2]',  EV($c)=$verify4[2],  ST($c)= 95, ET($c)= 95, AT($c)=$tol[2],\n";    $c++;
print OUT "FC($c)='V', PT($c)='$pt[3]',  EV($c)=$verify4[3],  ST($c)= 95, ET($c)= 95, AT($c)=$tol[3],\n";    $c++;
print OUT "FC($c)='V', PT($c)='$pt[4]',  EV($c)=$verify4[4],  ST($c)= 95, ET($c)= 95, AT($c)=$tol[4],\n";    $c++;
print OUT "FC($c)='V', PT($c)='$pt[5]',  EV($c)=$verify4[5],  ST($c)= 95, ET($c)= 95, AT($c)=$tol[5],\n";    $c++;
print OUT "FC($c)='V', PT($c)='$pt[6]',  EV($c)=$verify4[6],  ST($c)= 95, ET($c)= 95, AT($c)=$tol[6],\n";    $c++;
print OUT "FC($c)='V', PT($c)='$pt[7]',  EV($c)=$verify4[7],  ST($c)= 95, ET($c)= 95, AT($c)=$tol[7],\n";    $c++;
print OUT "FC($c)='V', PT($c)='$pt[8]',  EV($c)=$verify4[8],  ST($c)= 95, ET($c)= 95, AT($c)=$tol[8],\n";    $c++;
print OUT "FC($c)='V', PT($c)='$pt[9]',  EV($c)=$verify4[9],  ST($c)= 95, ET($c)= 95, AT($c)=$tol[9],\n";    $c++;
print OUT "FC($c)='V', PT($c)='$pt[10]', EV($c)=$verify4[10],  ST($c)= 95, ET($c)= 95, AT($c)=$tol[10],\n";  $c++;
print OUT "FC($c)='V', PT($c)='$pt[11]', EV($c)=$verify4[11],  ST($c)= 95, ET($c)= 95, AT($c)=$tol[11],\n";  $c++;
print OUT "FC($c)='V', PT($c)='$pt[12]', EV($c)=$verify4[12],  ST($c)= 95, ET($c)= 95, AT($c)=$tol[12],\n";  $c++;
print OUT "FC($c)='V', PT($c)='$pt[13]', EV($c)=$verify4[13],  ST($c)= 95, ET($c)= 95, AT($c)=$tol[13],\n";  $c++;
print OUT "FC($c)='V', PT($c)='$pt[14]', EV($c)=$verify4[14],  ST($c)= 95, ET($c)= 95, AT($c)=$tol[14],\n";  $c++;
print OUT "FC($c)='V', PT($c)='$pt[15]', EV($c)=$verify4[15],  ST($c)= 95, ET($c)= 95, AT($c)=$tol[15],\n";  $c++;

foreach $dup (@dups){
	print OUT "FC($c)='V', PT($c)='$dup->{PNTNAME}', EV($c)= $dup->{EXP75}, EQ($c)='R', ST($c)= 20, ET($c)= 20, AT($c)=$dup->{TOL},\n";  $c++;
}

print OUT "CO='Set 100%', \n";
print OUT "FC($c)='S', PT($c)='DASTST01A01', IV($c)= $in5[0],  ST($c)= 100, ET($c)= 100, \n"; $c++;
print OUT "FC($c)='S', PT($c)='DASTST01A02', IV($c)= $in5[1],  ST($c)= 100, ET($c)= 100, \n"; $c++;
print OUT "FC($c)='S', PT($c)='DASTST01A03', IV($c)= $in5[2],  ST($c)= 100, ET($c)= 100, \n"; $c++;
print OUT "FC($c)='S', PT($c)='DASTST01A04', IV($c)= $in5[3],  ST($c)= 100, ET($c)= 100, \n"; $c++;
print OUT "FC($c)='S', PT($c)='DASTST01A05', IV($c)= $in5[4],  ST($c)= 100, ET($c)= 100, \n"; $c++;
print OUT "FC($c)='S', PT($c)='DASTST01A06', IV($c)= $in5[5],  ST($c)= 100, ET($c)= 100, \n"; $c++;
print OUT "FC($c)='S', PT($c)='DASTST01A07', IV($c)= $in5[6],  ST($c)= 100, ET($c)= 100, \n"; $c++;
print OUT "FC($c)='S', PT($c)='DASTST01A08', IV($c)= $in5[7],  ST($c)= 100, ET($c)= 100, \n"; $c++;
print OUT "FC($c)='S', PT($c)='DASTST01A09', IV($c)= $in5[8],  ST($c)= 100, ET($c)= 100, \n"; $c++;
print OUT "FC($c)='S', PT($c)='DASTST01A10', IV($c)= $in5[9],  ST($c)= 100, ET($c)= 100, \n"; $c++;
print OUT "FC($c)='S', PT($c)='DASTST01A11', IV($c)= $in5[10], ST($c)= 100, ET($c)= 100, \n"; $c++;
print OUT "FC($c)='S', PT($c)='DASTST01A12', IV($c)= $in5[11], ST($c)= 100, ET($c)= 100, \n"; $c++;
print OUT "FC($c)='S', PT($c)='DASTST01A13', IV($c)= $in5[12], ST($c)= 100, ET($c)= 100, \n"; $c++;
print OUT "FC($c)='S', PT($c)='DASTST01A14', IV($c)= $in5[13], ST($c)= 100, ET($c)= 100, \n"; $c++;
print OUT "FC($c)='S', PT($c)='DASTST01A15', IV($c)= $in5[14], ST($c)= 100, ET($c)= 100, \n"; $c++;
print OUT "FC($c)='S', PT($c)='DASTST01A16', IV($c)= $in5[15], ST($c)= 100, ET($c)= 100, \n"; $c++;

print OUT "CO='Verify 100%', \n";
print OUT "FC($c)='V', PT($c)='$pt[0]',  EV($c)=$verify5[0],   EQ(145)='R', ST($c)= 120, ET($c)= 120, AT($c)=$tol[0],\n";   $c++;
print OUT "FC($c)='V', PT($c)='$pt[1]',  EV($c)=$verify5[1],   EQ(146)='R', ST($c)= 120, ET($c)= 120, AT($c)=$tol[1],\n";   $c++;
print OUT "FC($c)='V', PT($c)='$pt[2]',  EV($c)=$verify5[2],   EQ(147)='R', ST($c)= 120, ET($c)= 120, AT($c)=$tol[2],\n";   $c++;
print OUT "FC($c)='V', PT($c)='$pt[3]',  EV($c)=$verify5[3],   EQ(148)='R', ST($c)= 120, ET($c)= 120, AT($c)=$tol[3],\n";   $c++;
print OUT "FC($c)='V', PT($c)='$pt[4]',  EV($c)=$verify5[4],   EQ(149)='R', ST($c)= 120, ET($c)= 120, AT($c)=$tol[4],\n";   $c++;
print OUT "FC($c)='V', PT($c)='$pt[5]',  EV($c)=$verify5[5],   EQ(150)='R', ST($c)= 120, ET($c)= 120, AT($c)=$tol[5],\n";   $c++;
print OUT "FC($c)='V', PT($c)='$pt[6]',  EV($c)=$verify5[6],   EQ(151)='R', ST($c)= 120, ET($c)= 120, AT($c)=$tol[6],\n";   $c++;
print OUT "FC($c)='V', PT($c)='$pt[7]',  EV($c)=$verify5[7],   EQ(152)='R', ST($c)= 120, ET($c)= 120, AT($c)=$tol[7],\n";   $c++;
print OUT "FC($c)='V', PT($c)='$pt[8]',  EV($c)=$verify5[8],   EQ(153)='R', ST($c)= 120, ET($c)= 120, AT($c)=$tol[8],\n";   $c++;
print OUT "FC($c)='V', PT($c)='$pt[9]',  EV($c)=$verify5[9],   EQ(154)='R', ST($c)= 120, ET($c)= 120, AT($c)=$tol[9],\n";   $c++;
print OUT "FC($c)='V', PT($c)='$pt[10]', EV($c)=$verify5[10],  EQ(155)='R', ST($c)= 120, ET($c)= 120, AT($c)=$tol[10],\n";  $c++;
print OUT "FC($c)='V', PT($c)='$pt[11]', EV($c)=$verify5[11],  EQ(156)='R', ST($c)= 120, ET($c)= 120, AT($c)=$tol[11],\n";  $c++;
print OUT "FC($c)='V', PT($c)='$pt[12]', EV($c)=$verify5[12],  EQ(157)='R', ST($c)= 120, ET($c)= 120, AT($c)=$tol[12],\n";  $c++;
print OUT "FC($c)='V', PT($c)='$pt[13]', EV($c)=$verify5[13],  EQ(158)='R', ST($c)= 120, ET($c)= 120, AT($c)=$tol[13],\n";  $c++;
print OUT "FC($c)='V', PT($c)='$pt[14]', EV($c)=$verify5[14],  EQ(159)='R', ST($c)= 120, ET($c)= 120, AT($c)=$tol[14],\n";  $c++;
print OUT "FC($c)='V', PT($c)='$pt[15]', EV($c)=$verify5[15],  EQ(160)='R', ST($c)= 120, ET($c)= 120, AT($c)=$tol[15],\n";  $c++;

foreach $dup (@dups){
	print OUT "FC($c)='V', PT($c)='$dup->{PNTNAME}', EV($c)= $dup->{EXP100}, EQ($c)='R', ST($c)= 20, ET($c)= 20, AT($c)=$dup->{TOL},\n";  $c++;
}

print OUT "CO='Clear Test Bed', \n";
print OUT "FC($c)='S', PT($c)='DASTST01A01', IV($c)= 0, ST($c)= 125, ET($c)= 125, \n";  $c++;
print OUT "FC($c)='S', PT($c)='DASTST01A02', IV($c)= 0, ST($c)= 125, ET($c)= 125, \n";  $c++;
print OUT "FC($c)='S', PT($c)='DASTST01A03', IV($c)= 0, ST($c)= 125, ET($c)= 125, \n";  $c++;
print OUT "FC($c)='S', PT($c)='DASTST01A04', IV($c)= 0, ST($c)= 125, ET($c)= 125, \n";  $c++;
print OUT "FC($c)='S', PT($c)='DASTST01A05', IV($c)= 0, ST($c)= 125, ET($c)= 125, \n";  $c++;
print OUT "FC($c)='S', PT($c)='DASTST01A06', IV($c)= 0, ST($c)= 125, ET($c)= 125, \n";  $c++;
print OUT "FC($c)='S', PT($c)='DASTST01A07', IV($c)= 0, ST($c)= 125, ET($c)= 125, \n";  $c++;
print OUT "FC($c)='S', PT($c)='DASTST01A08', IV($c)= 0, ST($c)= 125, ET($c)= 125, \n";  $c++;
print OUT "FC($c)='S', PT($c)='DASTST01A09', IV($c)= 0, ST($c)= 125, ET($c)= 125, \n";  $c++;
print OUT "FC($c)='S', PT($c)='DASTST01A10', IV($c)= 0, ST($c)= 125, ET($c)= 125, \n";  $c++;
print OUT "FC($c)='S', PT($c)='DASTST01A11', IV($c)= 0, ST($c)= 125, ET($c)= 125, \n";  $c++;
print OUT "FC($c)='S', PT($c)='DASTST01A12', IV($c)= 0, ST($c)= 125, ET($c)= 125, \n";  $c++;
print OUT "FC($c)='S', PT($c)='DASTST01A13', IV($c)= 0, ST($c)= 125, ET($c)= 125, \n";  $c++;
print OUT "FC($c)='S', PT($c)='DASTST01A14', IV($c)= 0, ST($c)= 125, ET($c)= 125, \n";  $c++;
print OUT "FC($c)='S', PT($c)='DASTST01A15', IV($c)= 0, ST($c)= 125, ET($c)= 125, \n";  $c++;
print OUT "FC($c)='S', PT($c)='DASTST01A16', IV($c)= 0, ST($c)= 125, ET($c)= 125, \n";  $c++;
print OUT " &END\n";

close(OUT);
}

