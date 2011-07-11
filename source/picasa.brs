
Function LoadPicasa() As Object
    ' global singleton
    return m.picasa
End Function

Function InitPicasa() As Object
    ' constructor
    this = CreateObject("roAssociativeArray")
    this.protocol = "http"
    this.scope = this.protocol + "://picasaweb.google.com/data"
    this.prefix = this.scope + "/feed/api"
    this.oauth_prefix = "https://www.google.com/accounts"
    this.link_prefix = getLinkWebsite()
    
    this.ExecServerAPI = picasa_exec_api
    
    print "Picasa: init complete"
    return this
End Function


Function picasa_exec_api(url_stub="" As String, username="default" As Dynamic)
    oa = Oauth()
    
    if username=invalid then
        username=""
    else
        username="user/"+username
    end if
    
    http = NewHttp(m.prefix + "/" + username + url_stub)
    oa.sign(http,true)
    
    xml=http.getToStringWithTimeout(10)
    'print xml
    rsp=ParseXML(xml)
    if rsp=invalid then
        ShowErrorDialog("API return invalid. Try again later","Bad response")
    end if
    
    return rsp
End Function


' ********************************************************************
' ********************************************************************
' ***** Images
' ***** Images
' ********************************************************************
' ********************************************************************
Function picasa_new_image_list(xmllist As Object) As Object
    images=CreateObject("roList")
    for each record in xmllist
        image=picasa_new_image(record)
        if image.GetURL()<>invalid then
            images.Push(image)
        end if
    next
    
    return images
End Function

Function picasa_new_image(xml As Object) As Object
    image = CreateObject("roAssociativeArray")
    image.xml=xml
    image.GetURL=image_get_url
    return image
End Function

Function image_get_url()
    images=m.xml.GetNamedElements("media:group")[0].GetNamedElements("media:content")
    if images[0]<>invalid then
        return images[0].GetAttributes()["url"]
    end if
    
    return invalid
End Function
