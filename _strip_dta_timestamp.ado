program _strip_dta_timestamp
	/*** Replaces the timestamp in a dta file with "1 Jan 2020 12:00".
		 Doing so improves the binary stability of the saved dta file.
	***/
	
	version 16.0
	syntax using/
	
	qui dtaversion "`using'"
	if (`r(version)' == 118) python: strip_dta_timestamp(r"`using'")
	else {
		di "_strip_dta_timestamp only supports {help dta:version 118 dta files}"
		di `"no change made to `using'"'
	}
end

version 16.0
qui python query
if (substr("`r(version)'",1,1)=="2") {  // python version 2.x

python:
from __future__ import absolute_import
import re
from io import open

def strip_dta_timestamp(filename):

	fileObject = open(filename,u"rb+")
	firstLine = str(fileObject.readline())
	updatedLine = re.sub(str("<timestamp>\x11.*?</timestamp>").encode('utf-8'),str("<timestamp>\x11 1 Jan 2020 12:00</timestamp>").encode('utf-8'), firstLine, 1, flags=0)
	fileObject.seek(0)
	fileObject.write(updatedLine)
	fileObject.close()
end

}
else {  // python version 3.x

python:
import re

def strip_dta_timestamp(filename):
	fileObject = open(filename,"rb+")
	firstLine = bytes(fileObject.readline())
	updatedLine = re.sub(bytes("<timestamp>\x11.*?</timestamp>", 'utf-8'),bytes("<timestamp>\x11 1 Jan 2020 12:00</timestamp>", 'utf-8'), firstLine, 1, flags=0)
	fileObject.seek(0)
	fileObject.write(updatedLine)
	fileObject.close()
end
	
}
