program _strip_nonreproducibility_dta
	syntax anything(name=filename)
	python: python_strip_nonreproducibility_dta(r"`filename'")
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