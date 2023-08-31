//provider "aws" {
 // region = "eu-west-2"
//}

//resource "aws_s3_bucket" "www" {
//  bucket = "${var.www_domain_name}"//
 // acl    = "public-read"
 // policy = <<POLICY
//{
  //"Version":"2012-10-17",
  //"Statement":[
  //  {
  //    "Sid":"AddPerm",
  //    "Effect":"Allow",
  //   "Principal": "*",
  //    "Action":["s3:GetObject"],
   //   "Resource":["arn:aws:s3:::${var.www_domain_name}/*"]
  //  }
  //]
//}
//POLICY
//  website {
//    index_document = "index.html"
 //   error_document = "404.html"
 // }
//}
//aws s3 sync . s3: www.teddxo.com/

//terraform state show aws_s3_bucket.www | grep website_endpoint
//website_endpoint = www.teddxo.com.s3-website-eu-west-1.amazonaws.com

// Use the AWS Certificate Manager to create an SSL cert for our domain.
// This resource won't be created until you receive the email verifying you
//resource "aws_acm_certificate" "certificate" {
  // We want a wildcard cert so we can host subdomains later.
  //domain_name       = "*.${var.root_domain_name}"
  //validation_method = "ngozionuoha1@gmail.com"

  // We also want the cert to be valid for the root domain even though we'll be
  // redirecting to the www. domain immediately.
  //subject_alternative_names = ["${var.root_domain_name}"]
//}