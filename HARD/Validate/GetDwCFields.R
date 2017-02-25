require(data.table)
require(dplyr)
require(uuid)
require(digest)
require(httr)
require(xml2)

#Getting all the validator url for the Darwin Core fields
getDwcExtensions = function(url="http://tools.gbif.org/dwca-validator/extensions.do"){
  dwcExtUrl = httr::GET(url)
  xpath = '//div[@class="definition"]//div[@class="title"]//div[@class="head"]//a'
  x = xml2::xml_find_all(xml2::read_html(dwcExtUrl), xpath)
  # get Darwin Core Extensions and their attributes: extension name and url
  dwc_attr = xml_attr(x, 'href')
  dwc_text = xml_text(x)
  dwcExtensionList = setNames(as.list(dwc_attr), dwc_text)
  return(dwcExtensionList)
  
}

#To get various darwin core fields
getHtmlAttr = function(url, xpath) {
  # getHtmlAttr(url, xpath)
  # url: a valid url
  # xpath: what you want to get, for example:
  #        //div[@class="definition]
  htmlPage = httr::GET(url)
  HtmlAttr = xml2::xml_find_all(xml2::read_html(htmlPage), xpath)
  dwcTextize = gsub('\n|\t| ', '', xml2::xml_text((HtmlAttr)))
  return(dwcTextize)
  
}

#To load the fields :Occurence,Event,Measurement data etc.
loadDwCTerms = function(dwc_type) {
  # dwc_type: Event, 
  #
  dwcUrlBase = "http://tools.gbif.org/dwca-validator"
  dwcURL = paste(dwcUrlBase, dwc_type, sep=':')
  xpath = '//div[@class="definition"]//div[@class="title"]//div[@class="head"]' 
  # textize the result of DwC results
  dwcTextize = xml2::xml_text(getHtmlAttr(dwcURL, xpath))
  
  
  dwcEventPage = httr::GET("http://tools.gbif.org/dwca-validator/extension.do?id=dwc:Event")
  assign(
    'dwcEventTerms',
    gsub('\n|\t| ', '', xml2::xml_text(xml2::xml_find_all(x=xml2::read_html(dwcEventPage), xpath='//div[@class="definition"]//div[@class="title"]//div[@class="head"]'))),
    envir = .GlobalEnv
  )
  
  dwcMeasurementOrFactPage = httr::GET("http://tools.gbif.org/dwca-validator/extension.do?id=http://rs.iobis.org/obis/terms/ExtendedMeasurementOrFact")
  assign(
    'dwcMeasurementOrFactTerms',
    gsub('\n|\t| ', '', xml2::xml_text(xml2::xml_find_all(x=xml2::read_html(dwcMeasurementOrFactPage), xpath='//div[@class="definition"]//div[@class="title"]//div[@class="head"]'))),
    envir = .GlobalEnv
  )
  
  dwcOccurrencePage = httr::GET("http://tools.gbif.org/dwca-validator/extension.do?id=dwc:Occurrence")
  assign(
    'dwcOccurrenceTerms',
    gsub('\n|\t| ', '', xml2::xml_text(xml_find_all(x=read_html(dwcOccurrencePage), xpath='//div[@class="definition"]//div[@class="title"]//div[@class="head"]'))),
    envir = .GlobalEnv
  )
}


#Example:Prints the DwC fields in Event data.
#getHtmlAttr("http://tools.gbif.org/dwca-validator/extension.do?id=dwc:Event",'//div[@class="definition"]//div[@class="title"]//div[@class="head"]')

#To get all the urls:
getDwcExtensions()


#Will store all the DwC fields and then pass it to the valiate.R file for the validation of the data set.
