##############################################################
#
# Powershell script by Thierry Buisson
# Blog: http://www.thierrybuisson.fr
#
# Capture URL list in image format
#
# PSURLCapture.ps1 version 0.3 - 10/06/2011
#
##############################################################

#Get parameters
param (    
    [string]$ListFile = $(throw "Need a file containing a List of URL (e.g. ""c:\PSURLCapture\PSURLCapture.txt"")")
	,[string]$path = $null
	,[string]$width= $null
	,[string]$type= $null
	,[string]$delay = $null
)

#Initialize default variables values
$global:log		  	= ""
$gMinWidth			= "1128"
$gDelay				= "5000"
$gFileType			= "png"

#Log events
function Logging { 
 $logmsg = $args[0]
 $mylogtime = Get-Date -Format "yyyyMMdd-ThhmmssZ"; 
 $strLog = "[" + $mylogtime + "] "+ $logmsg
 Write-Host $strLog
 $global:log+=$strLog + "<br>";
}

#Zip function
function out-zip { 
 $zpath = $args[0] 
 $files = $input 

 if (-not $zpath.EndsWith('.zip')) {$zpath += '.zip'} 

 if (-not (test-path $zpath)) 
 { 
  set-content $zpath ("PK" + [char]5 + [char]6 + ("$([char]0)" * 18)) 
 } 

 $zipfile = (new-object -com shell.application).NameSpace($zpath) 
 $files | foreach {$zipfile.CopyHere($_.fullname) } 
} 

# From http://www.tellingmachine.net/?tag=/url+encoding
function Remove-IllegalCharacters([String] $DirtyString) {     
	if ([String]::IsNullOrEmpty($DirtyString))     
	{         
		return $DirtyString    
	}           
	Write-Debug $DirtyString    
	$CleanerString = $DirtyString -replace '[^\w -]', [String]::Empty     
	Write-Debug $CleanerString          
	return $CleanerString.Trim()
} 

function FormatUrlForImageFile([String] $myString) { 
	return Remove-IllegalCharacters $myString
}

function Screencapture ([string] $url , [string]$filepath, [string]$minwidth, [string]$delay ) {
   
   $arglst="--url=$url --out=$filepath"
   
   if ($minwidth){
		$arglst+=" --min-width=$minwidth"}
	else{
		$arglst+=" --min-width=$gMinWidth"}
		
	if ($delay){
		$arglst+=" --delay=$delay"}
	else{
		$arglst+=" --delay=$gDelay"}
		
   Logging ("Capture url $url in file $filepath with args $arglst");	
   $ProcessInfo = Start-Process ".\iecapt.exe" -argument $arglst -WindowStyle "hidden" 
   Logging ("Command return $ProcessInfo");
}

function OpenInIE($url){
	$ie = new-object -Com internetexplorer.application
	$ie.Navigate2($url)
	while($ie.busy){sleep 1}
	$ie.Navigate2($url)
	$ie.visible=$true
}

Logging("Starting capturing sites from $ListFile...")
Logging("Path is $path")

$lines = Get-Content $ListFile #| Sort-Object
foreach($l in $lines)
{       
	$niceURLName = FormatUrlForImageFile $l
	$FinalPath=".\"	
	
	#define default file type
	if ($type -eq ""){
		$filetype = "." + $gFileType
		}
	else{
		$filetype = "." + $type
	}
	
	#define full file path if designed
	if ($path){
		if (!(Test-Path -path $path)) 
		{ 
			Logging("Output directory doesn't exist, create file in default directory")
			$FinalPath=".\"
		}
		else{
			$FinalPath =  $path
		}
	}
	
	$_filepath  = $temppath + $niceURLName  + $filetype
	
	Screencapture $l $_filepath $width $delay
	#ScreenCaptureWithWebscreenCapture  $l $_filepath
}

Logging("SPCapture has ended...")
