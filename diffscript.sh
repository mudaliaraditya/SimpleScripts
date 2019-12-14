#!/bin/bash

ARRTODO=(cpp cc c h hpp sh)
#ArrDirectFileIgnoreCase=(makefile \.txt \.so \.out)
ArrDirectFileIgnoreCase=(makefile \\.txt \\.so \\.out \\.o )
NONSHOWDIR=(\.git)

DIFF_RESULT=""
#ArrDirectFileCase=(makefile)

#ARRTONODO=(.svn .git .jpg )

scriptname=$(basename "$0")
#scriptname=`echo $0 | rev | cut -d'/' -f1 | rev`
Usage()
{
   echo "USAGE : $scriptname \"/home/user/codepath1\" \"/home/user/codepath2\""

}

WriteForOnlyFileEGREP()
{
   PATH1=$1
   PATH2=$2
   PATTERN=$3
   FILEWRITE=$4
for i in  $(echo "$DIFf_RESULT" | grep -e "$PATTERN"|grep "Only" | sed  "s/: /\//g")
{
  EXTRA=""    
  if [ "$i" != "Only" -a "$i" != "in" ]
    then
    if [[ "$i" == "$PATH1"* ]]
    then
       #echo "matchpath1 $PATH1"
       EXTRA=`echo "$i" | sed "s:$PATH1::g" `
       MISSING=$PATH2
    fi
   if [[ "$i" == "$PATH2"* ]]
    then
       #echo "matchpath2 $PATH2"
       EXTRA=`echo "$i" | sed "s:$PATH2::g" `
       MISSING=$PATH1
    fi
    FOLDERPRESENT=`echo $EXTRA | rev | cut -d"/" -f2 | rev`  
    if [ -d "$FOLDERPRESENT"  -a "$FOLDERPRESENT" != "/" ]
    then
         echo "creating $FOLDERPRESENT"
         mkdir $FOLDERPRESENT
    fi
    echo "cp $i $MISSING/$EXTRA" >> $FILEWRITE
    #echo "FILE_PATH:$i MISSING:$MISSING EXTRA:$EXTRA"
    #echo "done"
  fi
}

}
WriteForOnlyFileDir()
{
   PATH1=$1
   PATH2=$2
   FILEWRITE=$3
for i in  $(echo "$DIFF_RESULT" |grep "Only" | sed  "s/: /\//g")
{
  EXTRA=""    
  if [ "$i" != "Only" -a "$i" != "in" ]
    then
    if [[ "$i" == "$PATH1"* ]]
    then
       #echo "matchpath1 $PATH1"
       EXTRA=`echo "$i" | sed "s:$PATH1::g" `
       MISSING=$PATH2
    fi
   if [[ "$i" == "$PATH2"* ]]
    then
       #echo "matchpath2 $PATH2"
       EXTRA=`echo "$i" | sed "s:$PATH2::g" `
       MISSING=$PATH1
    fi
    FOLDERPRESENT=`echo $EXTRA | rev | cut -d"/" -f2 | rev`  
    if [ -d "$i"  ]
    then
         #echo "creating $FOLDERPRESENT"
         #mkdir $FOLDERPRESENT
         echo "cp -r $i $MISSING/$EXTRA" >> $FILEWRITE
    fi
    #echo "FILE_PATH:$i MISSING:$MISSING EXTRA:$EXTRA"
    #echo "done"
  fi
}

}



WriteForOnlyFile()
{
   PATH1=$1
   PATH2=$2
   PATTERN=$3
   FILEWRITE=$4
for i in  $(echo "$DIFF_RESULT" | grep -i "$PATTERN"|grep "Only" | sed  "s/: /\//g")
{
  EXTRA=""    
  if [ "$i" != "Only" -a "$i" != "in" ]
    then
    if [[ "$i" == "$PATH1"* ]]
    then
       #echo "matchpath1 $PATH1"
       EXTRA=`echo "$i" | sed "s:$PATH1::g" `
       MISSING=$PATH2
    fi
   if [[ "$i" == "$PATH2"* ]]
    then
       #echo "matchpath2 $PATH2"
       EXTRA=`echo "$i" | sed "s:$PATH2::g" `
       MISSING=$PATH1
    fi
    FOLDERPRESENT=`echo $EXTRA | rev | cut -d"/" -f2 | rev`  
    if [ -d "$FOLDERPRESENT"  -a "$FOLDERPRESENT" != "/" ]
    then
         echo "creating $FOLDERPRESENT"
         mkdir $FOLDERPRESENT
    fi
    echo "cp $i $MISSING/$EXTRA" >> $FILEWRITE
    #echo "FILE_PATH:$i MISSING:$MISSING EXTRA:$EXTRA"
    #echo "done"
  fi
}

}


##################################
##            MAIN              ##
##################################
if [ $# -le 1 -o $# -ge 3 ]
then
   Usage 
   exit -1
fi

PATH1=$1
PATH2=$2

cd $PATH1
PATH1=`pwd`
cd -  1>/dev/null 2>&1
cd $PATH2
PATH2=`pwd`
cd -  1>/dev/null 2>&1

GREP_COMMAND=""

for i in "${ARRTODO[@]}"
do
   GREP_COMMAND="$GREP_COMMAND -e \"\.$i\""
done

DIFF_RESULT=`diff -qr "$PATH1" "$PATH2"`
#echo $DIFF_RESULT
#exit -1
echo "" > diffreport.txt
echo "=================================================" >> diffreport.txt
echo "=================DIFF_REPORT=====================">> diffreport.txt
echo "=================================================">> diffreport.txt
echo "difference between \"$PATH1\" and \"$PATH2\"">> diffreport.txt
echo "" >> diffreport.txt
echo "" >> diffreport.txt
echo "" >> diffreport.txt
echo "=================================================" >> diffreport.txt
echo "Source Files" >> diffreport.txt

DIFFERSCRIPT="echo \"$DIFF_RESULT\"  ""|"" grep $GREP_COMMAND  ""|"" grep \"Files\" ""|"" sed \"s/and//g\" ""|"" sed \"s/Files//g\" ""|"" sed \"s/differ//g\""
eval "$DIFFERSCRIPT" >>diffreport.txt

echo "SPECIAL FILES" >> diffreport.txt
A=0
for i in "${ArrDirectFileIgnoreCase[@]}"
do
   #eval "A=$[A + 1]"
   DIFFERSCRIPT="diff -qr \"$PATH1\" \"$PATH2\"  ""|"" grep -i \"$i\"  ""|"" grep \"Files\" ""|"" sed \"s/and//g\" ""|"" sed \"s/Files//g\" ""|"" sed \"s/differ//g\""
   #echo "$DIFFERSCRIPT" >> diffreport.txt
   eval "$DIFFERSCRIPT" >>diffreport.txt
   #echo "$A" >> diffreport.txt
done
echo "=================================================" >> diffreport.txt

echo "Non Existant " >> diffreport.txt
DIFFERSCRIPT="echo \"$DIFF_RESULT\"  ""|"" grep $GREP_COMMAND  ""|"" grep \"Only\" ""|"" sed \"s/and//g\" ""|"" sed \"s/Files//g\" ""|"" sed \"s/differ//g\""
eval "$DIFFERSCRIPT" >>diffreport.txt

WriteForOnlyFileEGREP $PATH1 $PATH2 $GREP_COMMAND diffreport.txt 
echo "=================================================" >> diffreport.txt
echo "SPECIAL FILES" >> diffreport.txt
for i in "${ArrDirectFileIgnoreCase[@]}"
do
   DIFFERSCRIPT="echo \"$DIFF_RESULT\"  ""|"" grep -i \"$i\"  ""|"" grep \"Only\" ""|"" sed \"s/and//g\" ""|"" sed \"s/Files//g\" ""|"" sed \"s/differ//g\""
   eval "$DIFFERSCRIPT" >>diffreport.txt
WriteForOnlyFile $PATH1 $PATH2 $i diffreport.txt
done
echo "=================================================" >> diffreport.txt

echo "Extra dir" >> diffreport.txt

WriteForOnlyFileDir  $PATH1 $PATH2 diffreport.txt


echo "=================================================" >> diffreport.txt
echo "All Files Different" >> diffreport.txt
echo "$DIFF_RESULT" >> diffreport.txt
echo "=================================================">> diffreport.txt
