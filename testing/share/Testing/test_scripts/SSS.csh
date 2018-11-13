#!/bin/tcsh

#Enter necessary filename variables here
set OutFile=$1
set TmpOut=${OutFile}_tmp.txt 
set InputDir=SSS
set Outputs=SSS_4/Rocflo/Modout/sss.prb_0001
set OutputsCheck=sss.prb_0001_check
set TestName=SSSRegressionTest

#Remove old test InputDir if present
if( -d  ${InputDir}) then
  echo "removing ${InputDir} directory"
  rm -r ${InputDir}
endif

#Make InputDir directory to run test in
mkdir ${InputDir}
cd ${InputDir}

#Copy input data into InputDir
cp -r $2/share/Testing/test_data/${InputDir}/* .

#Run executable to generate output data
gunzip ./SSS_data/Rocfrac/Grid5/sss.out.gz
setenv PATH "${3}:${PATH}"
$3/rocprep -A -o 1 4 -f 4 5 -n 4 -d ./SSS_data -t ./SSS_4
cd ./SSS_4
mpirun -np 4 $3/rocstar

cd ..

#Make sure the necesary output was generated
foreach file (${Outputs})
  if( ! -e ${file} ) then
    echo "No ${file} results file from run!"
    exit 1
  endif
end

#variable for test passing
@ result = 1

#diff the new output file with the saved one to check
#(This uses our own speical diff (diffdatafiles) that
#can compare numbers with a tolerance. See documentation
#for more information on how to use it.)
@ i = 1
foreach file (${Outputs})
  $4/diffdatafiles ${file} $OutputsCheck[$i] -t 1.0e-10 -n
  if($? != 0) then
    echo "${file} differs from $OutputsCheck[$i]"
    @ result = 0
  endif
  @ i += 1
end

#print test results to OutFile
printf "${TestName}=" >> ${TmpOut}
printf "$result\n" >> ${TmpOut}
cat ${TmpOut} >> ../${OutFile}
cd ..
#rm -r ${InputDir}

exit 0
