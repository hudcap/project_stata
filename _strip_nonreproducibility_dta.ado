program _strip_nonreproducibility_dta
	syntax anything(name=filename)
	
	dtaversion "`filename'"
	if `r(version)' == 118 {
		python: python_strip_nonreproducibility_dta(r"`filename'")
	}
	else {
		di "Cannot strip non-reproducibility for file: `filename' because it is saved from Stata version `r(version)'.  This feature is only written for version 118 saves (for stata version 14-16 saves with at most 2^15 variables)."
	}
end

python:
import re
def python_strip_nonreproducibility_dta(filename):
		import re
		fileObject = open(filename,"rb+")
		firstLine = bytes(fileObject.readline())
		updatedLine = re.sub(bytes("<timestamp>\x11.*?</timestamp>", 'utf-8'),bytes("<timestamp>\x11 1 Jan 2020 12:00</timestamp>", 'utf-8'), firstLine, 1, flags=0)
		fileObject.seek(0)
		fileObject.write(updatedLine)
		fileObject.close()
end