require(data.table)
require(dplyr)
require(uuid)
require(digest)
require(httr)
require(xml2)


getDwcExtensions = function(url="http://tools.gbif.org/dwca-validator/extensions.do"){
    dwcExtUrl = httr::GET(url)
    xpath = '//div[@class="definition"]//div[@class="title"]//div[@class="head"]//a'
    x = xml2::xml_find_all(xml2::read_html(dwcExtUrl), xpath)
    # get Darwin Core Extensions and their attributes: extension name and url
    dwc_attr = xml_attr(x, 'href')
    dwc_text = xml_text(x)
    dwcExtensionList = setNames(as.list(dwc_attr), dwc_text)
    return(dwcExtensionList)
    # save data image DwcExtList
    # save(DwcExtList, 'data/DwcExtList.RData')
}

getHtmlAttr = function(url, xpath) {
    # getHtmlAttr(url, xpath)
    # url: a valid url
    # xpath: what you want to get, for example:
    #        //div[@class="definition]
    htmlPage = httr::GET(url)
    HtmlAttr = xml2::xml_find_all(xml2::read_html(htmlPage), xpath)
    return(HtmlAttr)
}

getDwcTerms = function(dwc_type){
    # we will use gbif darwin core archive validator to get darwin
    # core extention terms
    data(DwcExtList)
    dwcExtUrl = DwcExtList[dwc_type]
    dwcUrlBase = "http://tools.gbif.org/dwca-validator" 
    dwcURL = paste(dwcUrlBase, dwcExtUrl, sep='/')
    xpath = '//div[@class="definition"]//div[@class="title"]//div[@class="head"]' 
    # textize the result of DwC results
    # note: we removed break new lines, tab and space
    dwcTextize = gsub('\n|\t| ', '', xml2::xml_text(getHtmlAttr(dwcURL, xpath)))
    return(dwcTextize)   
}


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
