function OpenFile( fileUrl )
{
  window.top.opener.SetUrl( encodeURI( fileUrl ) ) ;
  window.top.close() ;
  window.top.opener.focus() ;
}
