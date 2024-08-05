variable "bucketName" {
  
  default="vishnu-terraform-bucket"
}



variable "mime_types" {
  default = {
    
    html  = "text/html"
    css   = "text/css"
    woff   = "font/woff"
    woff2   = "font/woff2"
    wav = "audio/wav"
    mp3    = "audio/mpeg3"
    js    = "application/javascript"
    cur= "application/octet-stream"
    png = "image/png"
  
  }
}