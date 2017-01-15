cap program drop dtachecksum
program define dtachecksum
	
	args file
	
	if inlist("`c(os)'","MacOSX","Unix") {  // only works on Mac and Unix
	
		cap dtaversion `file'
		if _rc==0 {  // only run custom command on dta files
			if inrange(r(version),113,115) {
			
				_checksum_sliceout using `file', startuntil(91) restartat(110)
				
			}
			else if inrange(r(version),117,118) {
			
				_findbinaryoffset using `file', search(<timestamp>)
				local startuntil = r(bytepos) - 1
				
				_findbinaryoffset using `file', search(</timestamp>)
				local restartat = r(bytepos) + 12
				
				_checksum_sliceout using `file', startuntil(`startuntil') restartat(`restartat')
			
			}
			else checksum `file'
		}
		else checksum `file'
		
	}
	else checksum `file'
	
end

* XX need to add error handling logic for what to do when my command line parsing commands fail
* --> can test that logic on windows machine, where we know the custom checksum command won't work.


cap program drop _checksum_sliceout
program define _checksum_sliceout, rclass

	syntax using/, startuntil(integer) restartat(integer)
	
	* Compute CRC checksum while omitting timestamp
	tempfile csum_outfile
	qui !{ head -c `startuntil' `using' & tail -c +`restartat' `using'; } | cksum > `csum_outfile'
	
	* Load CRC checksum
	file open csum_result using `csum_outfile', read text
	file read csum_result csum_toparse
	file close csum_result
	tokenize "`csum_toparse'"
	
	* Print CRC checksum result
	di "{bf}Checksum (timestamp invariant) for `using' = `1', size = `2'"
	
	* Return CRC checksum results
	return clear
	return scalar checksum = `1'
	return scalar filelen = `2'
	return scalar version = -1
	
end


cap program drop _findbinaryoffset
program define _findbinaryoffset, rclass

	syntax using/, search(string)
	
	* Search the specified file for the search string, output first match
	tempfile outfile
	qui !strings -t d `using' | grep -m 1 "`search'" > `outfile'
	
	* Load offset data
	file open offset_result using `outfile', read text
	file read offset_result offset_toparse
	file close offset_result
	
	* Separate offset start from the remaining string
	tokenize "`offset_toparse'"
	local shiftstart = `1'
	mac shift
	
	* Compute the starting byte position of the search string
	local bytepos = `shiftstart' + strpos("`*'","`search'")
	
	* Return the starting byte position
	return clear
	return scalar bytepos = `bytepos'

end

